validation() {
    dummy=""
    while [[ "$dummy" != "y" && "$dummy" != "n" ]]; do
        read -p " $1 " dummy
        dummy="${dummy,,}"
        if [[ "$dummy" == "" ]]; then
            dummy="y"
        fi
        if [[ "$dummy" != "y" && "$dummy" != "n" ]]; then
            echo "Try again typing only 'Y' or 'n'." >&2
            echo "" >&2
        fi
    done
    echo "$dummy"
}

