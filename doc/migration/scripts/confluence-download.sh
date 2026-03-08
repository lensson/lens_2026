#!/bin/bash
# ==============================================================================
# Confluence 下载脚本
# 将 Confluence WIKI 页面内容下载并转换回 Markdown
#
# 空间: ~zhenac（个人空间）
#
# 支持的页面（默认 Roadmap）:
#   Roadmap  ←→  ../roadmap.md
#   Request  ←→  ../request.md
#
# 用法:
#   ./confluence-download.sh                              # 下载 Roadmap → roadmap.md
#   ./confluence-download.sh -t Request -f ../request.md # 下载 Request → request.md
#   ./confluence-download.sh -u zhenac -p mypass
#   ./confluence-download.sh -n                           # dry-run，只预览不写文件
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

CONFLUENCE_BASE="https://confluence.ext.net.nokia.com"
CONFLUENCE_SPACE="~zhenac"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 默认值 ────────────────────────────────────────────────────────────────────
PAGE_TITLE="Roadmap"
MD_FILE="${SCRIPT_DIR}/../roadmap.md"
DRY_RUN=false
CONFLUENCE_USER="${CONFLUENCE_USER:-}"
CONFLUENCE_PASS="${CONFLUENCE_PASS:-}"

while getopts "u:p:t:f:nh" opt; do
    case $opt in
        u) CONFLUENCE_USER="$OPTARG" ;;
        p) CONFLUENCE_PASS="$OPTARG" ;;
        t) PAGE_TITLE="$OPTARG" ;;
        f) MD_FILE="$OPTARG" ;;
        n) DRY_RUN=true ;;
        h)
            echo "用法: $0 [-u 用户名] [-p 密码] [-t 页面标题] [-f md文件路径] [-n dry-run]"
            echo ""
            echo "示例:"
            echo "  $0                                    # Roadmap → roadmap.md"
            echo "  $0 -t Request -f ../request.md        # Request → request.md"
            echo "  $0 -t Roadmap -n                      # 预览 Roadmap 内容"
            exit 0 ;;
        *) echo "使用 -h 查看帮助"; exit 1 ;;
    esac
done
for arg in "$@"; do [ "$arg" = "--dry-run" ] && DRY_RUN=true; done

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
echo -e "${BLUE}  Confluence 下载${NC}"
[ "$DRY_RUN" = "true" ] && echo -e "${YELLOW}  [DRY-RUN 模式：只预览，不写入文件]${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "  源页面:   ${YELLOW}${CONFLUENCE_BASE}/display/${CONFLUENCE_SPACE}/${PAGE_TITLE}${NC}"
echo -e "  目标文件: ${YELLOW}$MD_FILE${NC}\n"

# ── Step 1: 验证凭据 ──────────────────────────────────────────────────────────
echo -e "${YELLOW}Step 1: 验证凭据...${NC}"
AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 \
    -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
    "${CONFLUENCE_BASE}/rest/api/user/current")
[ "$AUTH_TEST" != "200" ] && { echo -e "${RED}❌ 认证失败（HTTP $AUTH_TEST）${NC}"; exit 1; }
echo -e "  ${GREEN}✓ 认证成功${NC}"

# ── Step 2: 获取页面内容 ──────────────────────────────────────────────────────
echo -e "${YELLOW}Step 2: 获取页面 \"${PAGE_TITLE}\"...${NC}"
TMP_PAGE=$(mktemp /tmp/cf_page_XXXXXX.json)
HTTP_CODE=$(curl -s -o "$TMP_PAGE" -w "%{http_code}" --max-time 15 \
    -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
    "${CONFLUENCE_BASE}/rest/api/content?title=${PAGE_TITLE}&spaceKey=${CONFLUENCE_SPACE}&expand=version,body.storage")

[ "$HTTP_CODE" != "200" ] && {
    echo -e "${RED}❌ 获取失败（HTTP $HTTP_CODE）${NC}"
    cat "$TMP_PAGE"; rm -f "$TMP_PAGE"; exit 1
}

PAGE_EXISTS=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print('yes' if d.get('results') else 'no')" "$TMP_PAGE" 2>/dev/null)
[ "$PAGE_EXISTS" = "no" ] && { echo -e "${RED}❌ 页面 \"${PAGE_TITLE}\" 不存在${NC}"; rm -f "$TMP_PAGE"; exit 1; }

PAGE_VERSION=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print(d['results'][0]['version']['number'])" "$TMP_PAGE")

PAGE_MODIFIED=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print(d['results'][0]['version'].get('when','unknown'))" "$TMP_PAGE" 2>/dev/null || echo "unknown")

echo -e "  ${GREEN}✓ 找到页面（v${PAGE_VERSION}，最后修改: ${PAGE_MODIFIED}）${NC}"

# ── Step 3: Storage Format → Markdown ────────────────────────────────────────
echo -e "${YELLOW}Step 3: 转换为 Markdown...${NC}"

TMP_PY=$(mktemp /tmp/cf2md_XXXXXX.py)
cat > "$TMP_PY" << 'ENDPY'
import sys, re, json

def clean(html):
    html = re.sub(r'<strong><em>(.*?)</em></strong>', r'***\1***', html, flags=re.DOTALL)
    html = re.sub(r'<strong>(.*?)</strong>', r'**\1**', html, flags=re.DOTALL)
    html = re.sub(r'<em>(.*?)</em>', r'*\1*', html, flags=re.DOTALL)
    html = re.sub(r'<code>(.*?)</code>', r'`\1`', html, flags=re.DOTALL)
    html = re.sub(r'<a href="([^"]+)">(.*?)</a>', r'[\2](\1)', html, flags=re.DOTALL)
    html = re.sub(r'<del>(.*?)</del>', r'~~\1~~', html, flags=re.DOTALL)
    html = re.sub(r'<[^>]+>', '', html)
    return html.replace('&amp;','&').replace('&lt;','<').replace('&gt;','>').replace('&nbsp;',' ').strip()

def convert(html):
    def code_block(m):
        lang_m = re.search(r'ac:name="language"[^>]*>([^<]*)', m.group(0))
        lang = lang_m.group(1).strip() if lang_m else ''
        body = re.search(r'<!\[CDATA\[(.*?)\]\]>', m.group(0), re.DOTALL)
        body = body.group(1) if body else ''
        return f'\n```{lang}\n{body}\n```\n'
    html = re.sub(r'<ac:structured-macro ac:name="code">.*?</ac:structured-macro>',
                  code_block, html, flags=re.DOTALL)
    def table_block(m):
        rows = re.findall(r'<tr>(.*?)</tr>', m.group(0), re.DOTALL)
        result = []; sep_done = False
        for row in rows:
            ths = re.findall(r'<th[^>]*>(.*?)</th>', row, re.DOTALL)
            tds = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)
            cells = [clean(c) for c in (ths or tds)]
            result.append('| ' + ' | '.join(cells) + ' |')
            if ths and not sep_done:
                result.append('|' + '|'.join(['---']*len(cells)) + '|'); sep_done = True
        return '\n' + '\n'.join(result) + '\n'
    html = re.sub(r'<table>.*?</table>', table_block, html, flags=re.DOTALL)
    for l in range(6, 0, -1):
        html = re.sub(f'<h{l}[^>]*>(.*?)</h{l}>',
                      lambda m, lv=l: '\n' + '#'*lv + ' ' + clean(m.group(1)) + '\n',
                      html, flags=re.DOTALL)
    html = re.sub(r'<[ou]l>', '\n', html)
    html = re.sub(r'</[ou]l>', '\n', html)
    html = re.sub(r'<li>(.*?)</li>',
                  lambda m: '- ' + clean(m.group(1)) + '\n', html, flags=re.DOTALL)
    html = re.sub(r'<p>(.*?)</p>',
                  lambda m: '\n' + clean(m.group(1)) + '\n', html, flags=re.DOTALL)
    html = re.sub(r'<hr\s*/?>', '\n---\n', html)
    html = re.sub(r'<[^>]+>', '', html)
    html = html.replace('&amp;','&').replace('&lt;','<').replace('&gt;','>').replace('&nbsp;',' ')
    html = re.sub(r'\n{3,}', '\n\n', html)
    return html.strip()

with open(sys.argv[1]) as f:
    d = json.load(f)
storage = d['results'][0]['body']['storage']['value']
print(convert(storage))
ENDPY

TMP_MD=$(mktemp /tmp/cf_md_XXXXXX.md)
python3 "$TMP_PY" "$TMP_PAGE" > "$TMP_MD"
rm -f "$TMP_PY" "$TMP_PAGE"

MD_SIZE=$(wc -c < "$TMP_MD")
[ "$MD_SIZE" -lt 10 ] && { echo -e "${RED}❌ 内容为空或转换失败${NC}"; rm -f "$TMP_MD"; exit 1; }
echo -e "  ${GREEN}✓ 转换完成（${MD_SIZE} 字节）${NC}"

# ── Step 4: 写入文件（或 dry-run 预览）──────────────────────────────────────
if [ "$DRY_RUN" = "true" ]; then
    echo ""
    echo -e "${YELLOW}── DRY-RUN 预览（前 30 行）────────────────────────${NC}"
    head -30 "$TMP_MD"
    echo -e "${YELLOW}────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}[DRY-RUN] 未写入文件${NC}"
    rm -f "$TMP_MD"
else
    echo -e "${YELLOW}Step 4: 备份并写入文件...${NC}"
    MD_BASENAME=$(basename "$MD_FILE")
    BACKUP="${MD_FILE}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$MD_FILE" "$BACKUP" 2>/dev/null && echo -e "  ${GREEN}✓ 备份至: $BACKUP${NC}" || true
    find "$(dirname "$MD_FILE")" -name "${MD_BASENAME}.bak.*" -mtime +3 -delete 2>/dev/null || true
    cp "$TMP_MD" "$MD_FILE"
    rm -f "$TMP_MD"
    echo -e "  ${GREEN}✓ $MD_FILE 已更新${NC}"
fi

echo -e "\n${GREEN}══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ 下载完成（Confluence v${PAGE_VERSION}）${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"

