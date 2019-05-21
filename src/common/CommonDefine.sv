`define forward( iname, srclogic , dstlogic) \
    Forward iname(\
        .*,\
        `rdyack_connect(src, srclogic),\
        `rdyack_connect(dst, dstlogic)\
    );
`define ignore( iname, srclogic , dstlogic , cond  )\
    Ignore iname(\
        .*,\
        .ignore(),\
        `rdyack_connect(src, srclogic),\
        `rdyack_connect(dst, dstlogic)\
    );
