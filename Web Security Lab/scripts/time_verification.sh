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

echo short message DSA:
avg_time 100 gpg --verify short_message_DSA.sig short_message
echo long message DSA:
avg_time 100 gpg --verify long_message_DSA.sig long_message

echo short message RSA:
avg_time 100 gpg --verify short_message_RSA.sig short_message
echo long message RSA:
avg_time 100 gpg --verify long_message_RSA.sig long_message
