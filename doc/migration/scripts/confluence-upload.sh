#!/bin/bash
# ==============================================================================
# Confluence 上传脚本
# 将本地 Markdown 文件同步到 Confluence WIKI 页面
#
# 空间: ~zhenac（个人空间）
#
# 支持的页面（默认 Roadmap）:
#   Roadmap  ←→  ../roadmap.md
#   Request  ←→  ../request.md
#   Hardware ←→  ../HARDWARE_AND_MODEL_GUIDE.md
#
# 用法:
#   ./confluence-upload.sh                                         # 上传 roadmap.md → Roadmap
#   ./confluence-upload.sh -t Request -f ../request.md             # 上传 request.md → Request
#   ./confluence-upload.sh -t Hardware -f ../HARDWARE_AND_MODEL_GUIDE.md  # 上传 hardware
#   ./confluence-upload.sh -u zhenac -p mypass                     # 指定凭据
#   CONFLUENCE_USER=zhenac CONFLUENCE_PASS=xxx ./confluence-upload.sh
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

CONFLUENCE_BASE="https://confluence.ext.net.nokia.com"
CONFLUENCE_SPACE="~zhenac"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 默认值 ────────────────────────────────────────────────────────────────────
PAGE_TITLE="Roadmap"
MD_FILE="${SCRIPT_DIR}/../roadmap.md"
CONFLUENCE_USER="${CONFLUENCE_USER:-}"
CONFLUENCE_PASS="${CONFLUENCE_PASS:-}"

while getopts "u:p:t:f:h" opt; do
    case $opt in
        u) CONFLUENCE_USER="$OPTARG" ;;
        p) CONFLUENCE_PASS="$OPTARG" ;;
        t) PAGE_TITLE="$OPTARG" ;;
        f) MD_FILE="$OPTARG" ;;
        h)
            echo "用法: $0 [-u 用户名] [-p 密码] [-t 页面标题] [-f md文件路径]"
            echo ""
            echo "示例:"
            echo "  $0                                    # roadmap.md → Roadmap"
            echo "  $0 -t Request -f ../request.md        # request.md → Request"
            echo "  $0 -t Roadmap -u zhenac -p mypass"
            exit 0 ;;
        *) echo "使用 -h 查看帮助"; exit 1 ;;
    esac
done

MD_FILE="$(realpath "$MD_FILE")"

if [ -z "$CONFLUENCE_USER" ]; then
    printf "Confluence 用户名: " > /dev/tty
    read -r CONFLUENCE_USER < /dev/tty
fi
if [ -z "$CONFLUENCE_PASS" ]; then
    printf "Confluence 密码: " > /dev/tty
    read -rs CONFLUENCE_PASS < /dev/tty
    echo "" > /dev/tty
fi

echo -e "\n${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Confluence 上传${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "  源文件:   ${YELLOW}$MD_FILE${NC}"
echo -e "  目标页面: ${YELLOW}${CONFLUENCE_BASE}/display/${CONFLUENCE_SPACE}/${PAGE_TITLE}${NC}\n"

[ ! -f "$MD_FILE" ] && { echo -e "${RED}❌ 找不到文件: $MD_FILE${NC}"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo -e "${RED}❌ 需要安装 curl${NC}"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo -e "${RED}❌ 需要安装 python3${NC}"; exit 1; }

# ── Step 1: 验证凭据 ──────────────────────────────────────────────────────────
echo -e "${YELLOW}Step 1: 验证凭据...${NC}"
AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 \
    -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
    "${CONFLUENCE_BASE}/rest/api/user/current")
[ "$AUTH_TEST" != "200" ] && { echo -e "${RED}❌ 认证失败（HTTP $AUTH_TEST），请检查用户名密码${NC}"; exit 1; }
echo -e "  ${GREEN}✓ 认证成功${NC}"

# ── Step 2: 查找页面 ──────────────────────────────────────────────────────────
echo -e "${YELLOW}Step 2: 查找页面 \"${PAGE_TITLE}\"...${NC}"
PAGE_SEARCH=$(curl -s --max-time 15 \
    -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
    "${CONFLUENCE_BASE}/rest/api/content?title=${PAGE_TITLE}&spaceKey=${CONFLUENCE_SPACE}&expand=version")

PAGE_ID=$(echo "$PAGE_SEARCH" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); r=d.get('results',[]); print(r[0]['id'] if r else '')" 2>/dev/null)

if [ -z "$PAGE_ID" ]; then
    echo -e "  ${YELLOW}⚠ 页面不存在，将自动创建${NC}"
    CREATE_MODE=true
    CURRENT_VERSION=0
else
    CURRENT_VERSION=$(echo "$PAGE_SEARCH" | python3 -c \
        "import sys,json; d=json.load(sys.stdin); print(d['results'][0]['version']['number'])")
    echo -e "  ${GREEN}✓ 找到页面 ID=$PAGE_ID（当前 v${CURRENT_VERSION}）${NC}"
    CREATE_MODE=false
fi

# ── Step 3: Markdown → Confluence Storage Format ─────────────────────────────
echo -e "${YELLOW}Step 3: 转换 Markdown 格式...${NC}"

# 使用临时 Python 脚本文件，避免 heredoc 嵌套与参数转义问题
TMP_PY=$(mktemp /tmp/md2cf_XXXXXX.py)
cat > "$TMP_PY" << 'ENDPY'
import sys, re, json

def inline(text):
    text = text.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    text = re.sub(r'\*\*\*(.+?)\*\*\*', r'<strong><em>\1</em></strong>', text)
    text = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', text)
    text = re.sub(r'\*(.+?)\*', r'<em>\1</em>', text)
    text = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', text)
    text = re.sub(r'~~(.+?)~~', r'<del>\1</del>', text)
    return text

def convert(md):
    lines = md.split('\n')
    out = []; in_code = False; lang = ''; stack = []; in_table = False

    def flush():
        c = ''.join(f'</{t}>' for t in reversed(stack))
        stack.clear()
        return c

    for line in lines:
        if line.startswith('```'):
            if not in_code:
                in_code = True
                lang = line[3:].strip() or 'text'
                out.append(f'<ac:structured-macro ac:name="code"><ac:parameter ac:name="language">{lang}</ac:parameter><ac:plain-text-body><![CDATA[')
            else:
                in_code = False
                out.append(']]></ac:plain-text-body></ac:structured-macro>')
            continue
        if in_code:
            out.append(line)
            continue
        if '|' in line and line.strip().startswith('|'):
            if not in_table:
                in_table = True
                out.append('<table><tbody>')
            if re.match(r'^\|[\s\-:|]+\|$', line.strip()):
                continue
            cells = [c.strip() for c in line.strip().strip('|').split('|')]
            out.append('<tr>' + ''.join(f'<td>{inline(c)}</td>' for c in cells) + '</tr>')
            continue
        elif in_table:
            in_table = False
            out.append('</tbody></table>')
        m = re.match(r'^(#{1,6})\s+(.*)', line)
        if m:
            out.append(flush())
            l = len(m.group(1))
            text = inline(m.group(2))
            size = {1:'24.0px',2:'20.0px',3:'16.0px',4:'14.0px'}.get(l,'13.0px')
            out.append(f'<p><strong><span style="font-size: {size};">{text}</span></strong></p>')
            continue
        m = re.match(r'^(\s*)\d+\.\s+(.*)', line)
        if m:
            d = len(m.group(1))//2
            while len(stack) > d+1: out.append(f'</{stack.pop()}>')
            if len(stack) <= d: out.append('<ol>'); stack.append('ol')
            out.append(f'<li>{inline(m.group(2))}</li>')
            continue
        m = re.match(r'^(\s*)[-*]\s+(.*)', line)
        if m:
            d = len(m.group(1))//2
            while len(stack) > d+1: out.append(f'</{stack.pop()}>')
            if len(stack) <= d: out.append('<ul>'); stack.append('ul')
            out.append(f'<li>{inline(m.group(2))}</li>')
            continue
        if re.match(r'^---+$', line.strip()):
            out.append(flush())
            out.append('<hr/>')
            continue
        if not line.strip():
            out.append(flush())
            continue
        out.append(flush())
        out.append(f'<p>{inline(line)}</p>')

    out.append(flush())
    if in_table:
        out.append('</tbody></table>')
    return '\n'.join(out)

# 读取 MD 文件，输出转换后的 Storage Format
md_file = sys.argv[1]
title    = sys.argv[2]
space    = sys.argv[3]
version  = int(sys.argv[4])
create   = sys.argv[5] == 'true'

with open(md_file, encoding='utf-8') as f:
    storage = convert(f.read())

payload = {
    "type": "page",
    "title": title,
    "space": {"key": space},
    "body": {"storage": {"value": storage, "representation": "storage"}}
}
if not create:
    payload["version"] = {"number": version}

# 输出到 stdout（由 shell 写入临时 JSON 文件）
print(json.dumps(payload))
ENDPY

NEW_VERSION=$((CURRENT_VERSION + 1))
TMP_JSON=$(mktemp /tmp/cf_payload_XXXXXX.json)
TMP_RESP=$(mktemp /tmp/cf_resp_XXXXXX.json)

python3 "$TMP_PY" "$MD_FILE" "$PAGE_TITLE" "$CONFLUENCE_SPACE" "$NEW_VERSION" "$CREATE_MODE" > "$TMP_JSON"
rm -f "$TMP_PY"

[ ! -s "$TMP_JSON" ] && { echo -e "${RED}❌ JSON 构建失败${NC}"; exit 1; }
echo -e "  ${GREEN}✓ 格式转换完成${NC}"

# ── Step 4: 上传 ──────────────────────────────────────────────────────────────
echo -e "${YELLOW}Step 4: 上传到 Confluence...${NC}"

if [ "$CREATE_MODE" = "true" ]; then
    HTTP_CODE=$(curl -s -o "$TMP_RESP" -w "%{http_code}" --max-time 30 \
        -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
        -X POST -H "Content-Type: application/json" \
        -d "@${TMP_JSON}" "${CONFLUENCE_BASE}/rest/api/content")
else
    HTTP_CODE=$(curl -s -o "$TMP_RESP" -w "%{http_code}" --max-time 30 \
        -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
        -X PUT -H "Content-Type: application/json" \
        -d "@${TMP_JSON}" "${CONFLUENCE_BASE}/rest/api/content/${PAGE_ID}")
fi
rm -f "$TMP_JSON"

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    PAGE_URL=$(python3 -c "
import json
with open('${TMP_RESP}') as f: d=json.load(f)
l=d.get('_links',{})
print(l.get('base','${CONFLUENCE_BASE}') + l.get('webui',''))" \
    2>/dev/null || echo "${CONFLUENCE_BASE}/display/${CONFLUENCE_SPACE}/${PAGE_TITLE}")
    rm -f "$TMP_RESP"
    echo -e "\n${GREEN}══════════════════════════════════════════════════════${NC}"
    [ "$CREATE_MODE" = "true" ] \
        && echo -e "${GREEN}  ✅ 新页面创建成功！${NC}" \
        || echo -e "${GREEN}  ✅ 页面更新成功（v${NEW_VERSION}）！${NC}"
    echo -e "${GREEN}  🔗 $PAGE_URL${NC}"
    echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
else
    echo -e "${RED}❌ 上传失败（HTTP $HTTP_CODE）${NC}"
    python3 -m json.tool "$TMP_RESP" 2>/dev/null || cat "$TMP_RESP"
    rm -f "$TMP_RESP"
    exit 1
fi
