# Documentation defined in Library/Homebrew/cmd/shellenv.rb

# HOMEBREW_CELLAR and HOMEBREW_PREFIX are set by extend/ENV/super.rb
# HOMEBREW_REPOSITORY is set by bin/brew
# Leading colon in MANPATH prepends default man dirs to search path in Linux and macOS.
# Please do not submit PRs to remove it!
# shellcheck disable=SC2154
homebrew-shellenv() {
  if [[ "${HOMEBREW_PATH%%:"${HOMEBREW_PREFIX}"/sbin*}" == "${HOMEBREW_PREFIX}/bin" ]]
  then
    return
  fi

  if [[ -n "$1" ]]
  then
    HOMEBREW_SHELL_NAME="$1"
  else
    HOMEBREW_SHELL_NAME="$(/bin/ps -p "${PPID}" -c -o comm=)"
  fi

  case "${HOMEBREW_SHELL_NAME}" in
    fish | -fish)
      echo "set -gx HOMEBREW_PREFIX \"${HOMEBREW_PREFIX}\";"
      echo "set -gx HOMEBREW_CELLAR \"${HOMEBREW_CELLAR}\";"
      echo "set -gx HOMEBREW_REPOSITORY \"${HOMEBREW_REPOSITORY}\";"
      echo "fish_add_path -gP \"${HOMEBREW_PREFIX}/bin\" \"${HOMEBREW_PREFIX}/sbin\";"
      echo "set -q MANPATH; and set MANPATH[1] \":\$(string trim --left --chars=\":\" \$MANPATH[1])\";"
      echo "! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH \"${HOMEBREW_PREFIX}/share/info\" \$INFOPATH;"
      ;;
    csh | -csh | tcsh | -tcsh)
      echo "setenv HOMEBREW_PREFIX ${HOMEBREW_PREFIX};"
      echo "setenv HOMEBREW_CELLAR ${HOMEBREW_CELLAR};"
      echo "setenv HOMEBREW_REPOSITORY ${HOMEBREW_REPOSITORY};"
      echo "setenv PATH ${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:\$PATH;"
      echo "test \${?MANPATH} -eq 1 && setenv MANPATH :\${MANPATH};"
      echo "setenv INFOPATH ${HOMEBREW_PREFIX}/share/info\`test \${?INFOPATH} -eq 1 && echo :\${INFOPATH}\`;"
      ;;
    pwsh | -pwsh | pwsh-preview | -pwsh-preview)
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_PREFIX','${HOMEBREW_PREFIX}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_CELLAR','${HOMEBREW_CELLAR}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_REPOSITORY','${HOMEBREW_REPOSITORY}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('PATH',\$('${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:'+\$ENV:PATH),[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('MANPATH',\$('${HOMEBREW_PREFIX}/share/man'+\$(if(\${ENV:MANPATH}){':'+\${ENV:MANPATH}})+':'),[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('INFOPATH',\$('${HOMEBREW_PREFIX}/share/info'+\$(if(\${ENV:INFOPATH}){':'+\${ENV:INFOPATH}})),[System.EnvironmentVariableTarget]::Process)"
      ;;
    *)
      echo "export HOMEBREW_PREFIX=\"${HOMEBREW_PREFIX}\";"
      echo "export HOMEBREW_CELLAR=\"${HOMEBREW_CELLAR}\";"
      echo "export HOMEBREW_REPOSITORY=\"${HOMEBREW_REPOSITORY}\";"
      echo "export PATH=\"${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin\${PATH+:\$PATH}\";"
      echo "[ -z \"\${MANPATH-}\" ] || export MANPATH=\":\${MANPATH#:}\";"
      echo "export INFOPATH=\"${HOMEBREW_PREFIX}/share/info:\${INFOPATH:-}\";"
      ;;
  esac
}
