avg_time() { # usage: avg_time n command ..
    n=$1; shift
    (($# > 0)) || return                   # bail if no command given
    for ((i = 0; i < n; i++)); do
        { time -p "$@" &>/dev/null; } 2>&1 # ignore the output of the command
                                           # but collect time's output in stdout
    done | awk '
        /real/ { real = real + $2; nr++ }
        /user/ { user = user + $2; nu++ }
        /sys/  { sys  = sys  + $2; ns++}
        END    {if (nr>0) printf("\tAverage time: %.3f seconds\n", real/nr);}'
}

DSA_KEY=E0F69A843507D0698032ED02B0ECD5E8E07ACFEB
RSA_KEY=6F84B0E65B0E7D93796BC523F62A4B64909D220D

# these will prompt for passphrase if necassary before timing starts
gpg --batch --yes -u $DSA_KEY --output short_message_DSA.sig --detach-sign short_message
gpg --batch --yes -u $RSA_KEY --output short_message_RSA.sig --detach-sign short_message

# Perform the actual timing
echo short message DSA:
avg_time 100 gpg --batch --yes -u $DSA_KEY --output short_message_DSA.sig --detach-sign short_message
echo long message DSA:
avg_time 100 gpg --batch --yes -u $DSA_KEY --output long_message_DSA.sig --detach-sign long_message

echo short message RSA:
avg_time 100 gpg --batch --yes -u $RSA_KEY --output short_message_RSA.sig --detach-sign short_message
echo long message RSA:
avg_time 100 gpg --batch --yes -u $RSA_KEY --output long_message_RSA.sig --detach-sign long_message