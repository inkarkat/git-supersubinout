#!/bin/bash
set -o nounset

typeset -ar statusToBoolean=(true false)
case "$FAIL_ON_DIFFERENCES" in
    true)   typeset -ar statusToAnnotation=(error notice error)
	    typeset -ar statusToFinalStatus=(1 0)
	    ;;
    false)  typeset -ar statusToAnnotation=(warning notice error)
	    typeset -ar statusToFinalStatus=(0 0)
	    ;;
    *)      printf >&2 'ERROR: Invalid fail-on-differences: %s\n' "$FAIL_ON_DIFFERENCES"; exit 2;;
esac
typeset -ar statusToMessage=('Differences found between superproject and submodule(s)' 'No differences found between superproject and submodule(s)' 'An unexpected error occurred')

ansiLogs="$(git-supersubinout --color=always ${MESSAGE:+--message "$MESSAGE"} ${SUPER_BASE:+--super-base "$SUPER_BASE"} ${SUBMODULE_BASE:+--submodule-base "$SUBMODULE_BASE"})"; status=$?
logs="$(printf '%s\n' "$ansiLogs" | noansi)"
markdownLogs="$(printf '%s\n' "$ansiLogs" | ansi2markdown)"

printf 'differences-found=%s\nlogs<<EOF\n%s\nEOF\nmarkdown-logs<<EOF\n%s\nEOF\n' \
    "${statusToBoolean[$status]:-false}" "$logs" "$markdownLogs" \
    >> "$GITHUB_OUTPUT"
printf '::%s::%s\n' "${statusToAnnotation[$status]:-error}" "${statusToMessage[$status]:-${statusToMessage[2]}}"
exit ${statusToFinalStatus[$status]:-$status}
