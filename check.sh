#!/bin/bash
set -o nounset

typeset -ar statusToBoolean=(true false)
typeset -ar statusToAnnotation=(warning notice error)
typeset -ar statusToFinalStatus=(0 0)
typeset -ar statusToMessage=('Differences found between superproject and submodule(s)' 'No differences found between superproject and submodule(s)' 'An unexpected error occurred')

ansiLogs="$(GIT_SUPERSUBINOUT_MESSAGE_SINK='&1' git-supersubinout --color=always ${MESSAGE:+--message "$MESSAGE"} ${SUPER_BASE:+--super-base "$SUPER_BASE"} ${SUBMODULE_BASE:+--submodule-base "$SUBMODULE_BASE"})"; status=$?
logs="$(printf '%s\n' "$ansiLogs" | noansi)"
markdownLogs="$(printf '%s\n' "$ansiLogs" | ansi2markdown)"

printf '%s=%s\n%s<<EOF\n%s\nEOF\n%s<<EOF\n%s\nEOF\n' \
    "$OUTPUT_DIFFERENCES_FOUND" "${statusToBoolean[$status]:-false}" \
    "$OUTPUT_LOGS" "$logs" \
    "$OUTPUT_MARKDOWN_LOGS" "$markdownLogs" \
    >> "$GITHUB_OUTPUT"
printf '::%s::%s\n' "${statusToAnnotation[$status]:-error}" "${statusToMessage[$status]:-${statusToMessage[2]}}"
exit ${statusToFinalStatus[$status]:-$status}
