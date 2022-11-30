homebrew-items() {
  local items
  local sed_extended_regex_flag
  local find_include_filter="$1"
  local find_exclude_filter="$2"
  local sed_filter="$3"
  local grep_filter="$4"

  # HOMEBREW_MACOS is set by brew.sh
  # shellcheck disable=SC2154
  if [[ -n "${HOMEBREW_MACOS}" ]]
  then
    sed_extended_regex_flag="-E"
  else
    sed_extended_regex_flag="-r"
  fi

  # HOMEBREW_REPOSITORY is set by brew.sh
  # shellcheck disable=SC2154
  items="$(
    find "${HOMEBREW_REPOSITORY}/Library/Taps" \
      -type d \( \
      -name "${find_exclude_filter}" -o \
      -name cmd -o \
      -name .github -o \
      -name lib -o \
      -name spec -o \
      -name vendor \
      \) \
      -prune -false -o -path "${find_include_filter}" |
      sed "${sed_extended_regex_flag}" \
        -e 's/\.rb//g' \
        -e 's_.*/Taps/(.*)/(home|linux)brew-_\1/_' \
        -e "${sed_filter}"
  )"
  local shortnames
  shortnames="$(echo "${items}" | cut -d "/" -f 3)"
  echo -e "${items}\n${shortnames}" |
    grep -v "${grep_filter}" |
    sort -uf
}
