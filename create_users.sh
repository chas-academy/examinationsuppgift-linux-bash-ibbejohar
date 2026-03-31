#!/bin/bash

# Detta kollar root
check_root(){
    if [[ ! $(id -un) == "root" ]]; then
        echo "ERROR: not root"
        exit 1
    fi
}

check_input(){
    if [[ -z $1 ]]; then
        echo "Minst en användare måste ge"
        exit 1
    fi
}

# Skapar skeletstruktur för undermappar
create_temp_dir(){
    mkdir -p skel/Documents
    mkdir -p skel/Downloads
    mkdir -p skel/Work
}

# Rensar skeletstruktur för undermappar
cleanup(){
 rm -rf skel
}

# Skapar användare med hem och undermappar
# Ägaren bestäms också
create_user(){
    for user in "$@"
    do
        useradd -m "$user" -k skel && echo "Användare $user skapad"
    done
}

# Skapar välkommen fil med användares name och befintliga anvädare
create_welcome_file(){
    for user in "$@"
    do
        # Välkommen meddelande
        sudo -u "$user" sh -c 'echo "Välkommen $USER" > "$HOME/welcome.txt"' && echo "$user välkommen meddelande skapad"
        # Filtera endast riktiga användare och lägg till i welcome filen
        sudo -u "$user" sh -c "awk -F: '\$3 >= 1000 && \$3 <= 9999 {print \$1}' /etc/passwd >> \$HOME/welcome.txt"
        chmod -R 700 "/home/$user"
    done
}

main(){
check_root
check_input "$1"
create_temp_dir
create_user "$@"
create_welcome_file "$@"
cleanup
}


main "$@"
