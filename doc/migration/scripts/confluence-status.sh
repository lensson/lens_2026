#!/bin/bash
# ==============================================================================
# Confluence 同步状态检查
# 显示本地 Markdown 文件与对应 Confluence 页面的版本信息
#
# 用法:
#   ./confluence-status.sh                              # 检查所有已知页面
#   ./confluence-status.sh -t Roadmap                  # 只检查 Roadmap
#   ./confluence-status.sh -u zhenac -p mypass
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

CONFLUENCE_BASE="https://confluence.ext.net.nokia.com"
CONFLUENCE_SPACE="~zhenac"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFLUENCE_USER="${CONFLUENCE_USER:-}"
CONFLUENCE_PASS="${CONFLUENCE_PASS:-}"
FILTER_TITLE=""

while getopts "u:p:t:h" opt; do
    case $opt in
        u) CONFLUENCE_USER="$OPTARG" ;;
        p) CONFLUENCE_PASS="$OPTARG" ;;
        t) FILTER_TITLE="$OPTARG" ;;
        h) echo "用法: $0 [-u 用户名] [-p 密码] [-t 页面标题]"; exit 0 ;;
        *) exit 1 ;;
    esac
done

[ -z "$CONFLUENCE_USER" ] && read -rp "Confluence 用户名: " CONFLUENCE_USER
[ -z "$CONFLUENCE_PASS" ] && { read -rsp "Confluence 密码: " CONFLUENCE_PASS; echo ""; }

# ── 已知页面列表（标题:本地文件 的映射）──────────────────────────────────────
declare -A PAGES
PAGES["Roadmap"]="${SCRIPT_DIR}/../roadmap.md"
PAGES["Request"]="${SCRIPT_DIR}/../request.md"

echo -e "\n${BLUE}══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Confluence 同步状态检查${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════${NC}\n"

# ── 验证凭据 ──────────────────────────────────────────────────────────────────
AUTH_TEST=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 \
    -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
    "${CONFLUENCE_BASE}/rest/api/user/current")
[ "$AUTH_TEST" != "200" ] && { echo -e "${RED}❌ 认证失败（HTTP $AUTH_TEST）${NC}"; exit 1; }

# ── 逐页面检查 ────────────────────────────────────────────────────────────────
check_page() {
    local TITLE="$1"
    local LOCAL_FILE
    LOCAL_FILE="$(realpath "${PAGES[$TITLE]}" 2>/dev/null || echo "${PAGES[$TITLE]}")"

    echo -e "${CYAN}┌─ 页面: ${TITLE}${NC}"
    echo -e "${CYAN}│${NC}  URL: ${BLUE}${CONFLUENCE_BASE}/display/${CONFLUENCE_SPACE}/${TITLE}${NC}"

    # 本地文件信息
    if [ -f "$LOCAL_FILE" ]; then
        LOCAL_MODIFIED=$(stat -c "%y" "$LOCAL_FILE" 2>/dev/null | cut -d'.' -f1 || echo "unknown")
        LOCAL_LINES=$(wc -l < "$LOCAL_FILE")
        echo -e "${CYAN}│${NC}  本地: ${YELLOW}$LOCAL_FILE${NC}（${LOCAL_LINES} 行，${LOCAL_MODIFIED}）"
    else
        echo -e "${CYAN}│${NC}  本地: ${RED}文件不存在 $LOCAL_FILE${NC}"
    fi

    # Confluence 页面信息
    TMP_PAGE=$(mktemp /tmp/cf_status_XXXXXX.json)
    HTTP_CODE=$(curl -s -o "$TMP_PAGE" -w "%{http_code}" --max-time 15 \
        -u "${CONFLUENCE_USER}:${CONFLUENCE_PASS}" \
        "${CONFLUENCE_BASE}/rest/api/content?title=${TITLE}&spaceKey=${CONFLUENCE_SPACE}&expand=version" 2>/dev/null || echo "000")

    if [ "$HTTP_CODE" = "200" ]; then
        PAGE_EXISTS=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print('yes' if d.get('results') else 'no')" "$TMP_PAGE" 2>/dev/null || echo "no")

        if [ "$PAGE_EXISTS" = "yes" ]; then
            VER=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print(d['results'][0]['version']['number'])" "$TMP_PAGE")
            MOD=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print(d['results'][0]['version'].get('when','unknown'))" "$TMP_PAGE" 2>/dev/null || echo "unknown")
            AUTHOR=$(python3 -c "
import sys,json
with open(sys.argv[1]) as f: d=json.load(f)
print(d['results'][0]['version'].get('by',{}).get('displayName','unknown'))" "$TMP_PAGE" 2>/dev/null || echo "unknown")
            echo -e "${CYAN}│${NC}  远端: v${VER}，${MOD}，by ${AUTHOR}"
            echo -e "${CYAN}└─${NC} ${GREEN}✅ 页面存在，可同步${NC}"
        else
            echo -e "${CYAN}│${NC}  远端: ${YELLOW}页面不存在${NC}"
            echo -e "${CYAN}└─${NC} ${YELLOW}⚠ 上传后将自动创建${NC}"
        fi
    else
        echo -e "${CYAN}└─${NC} ${RED}❌ 无法连接（HTTP $HTTP_CODE）${NC}"
    fi
    rm -f "$TMP_PAGE"
    echo ""
}

if [ -n "$FILTER_TITLE" ]; then
    if [[ -v PAGES["$FILTER_TITLE"] ]]; then
        check_page "$FILTER_TITLE"
    else
        echo -e "${RED}❌ 未知页面: $FILTER_TITLE${NC}"
        echo "已知页面: ${!PAGES[*]}"
        exit 1
    fi
else
    for TITLE in "${!PAGES[@]}"; do
        check_page "$TITLE"
    done
fi

echo -e "可用操作："
echo -e "  ${YELLOW}./confluence-upload.sh${NC}                          上传 roadmap.md → Roadmap"
echo -e "  ${YELLOW}./confluence-upload.sh -t Request -f ../request.md${NC}  上传 request.md → Request"
echo -e "  ${YELLOW}./confluence-download.sh${NC}                         下载 Roadmap → roadmap.md"
echo -e "  ${YELLOW}./confluence-download.sh -t Request -f ../request.md${NC} 下载 Request → request.md"
echo -e "  ${YELLOW}./confluence-download.sh -t Request -f ../request.md -n${NC} 预览下载"
