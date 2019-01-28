`define forward( iname, srclogic , dstlogic) \
    Forward iname(\
        .*,\
        `rdyack_connect(src, srclogic),\
        `rdyack_connect(dst, dstlogic)\
    );
