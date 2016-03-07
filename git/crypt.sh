#   patterns representing private files
target_files=()
pattern='.*private([\.\/].*)?'
encrypted_signature_pattern='$ANSIBLE_VAULT;'
vault_password_file="deploy/private/vault_pass.txt"
exclude_files=("$vault_password_file", "deploy/private/.gitignore" "$vault_password_file.gpg")
private_files=()
function file_is_already_encrypted(){
    first_line=$(head -n 1 $1)
    [[ "$first_line" =~ "$encrypted_signature_pattern" ]] && return 0
    return 1
}
#   build array
staged_files="$(git diff --name-only --cached deploy)"
committed_files="$(git ls-tree --name-only -r @ deploy)"
for fyle in $staged_files $committed_files; do
    if [ -f $fyle ]; then
        if [[ "$fyle" =~ $pattern ]]; then
            if [[ ! ${exclude_files[@]} =~ "$fyle" ]]; then
                private_files+=("$fyle")
            fi
        fi
    fi
done
#   dedupe
private_files=($(printf "%s\n" "${private_files[@]}" | sort -u));
