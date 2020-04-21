# For information on the settings in this file, type "man shorewall-rules"
######################################################################################################################################################################################################
#ACTION		SOURCE			    DEST						                PROTO	DEST	SOURCE		ORIGINAL	RATE		USER/	MARK	CONNLIMIT	TIME		HEADERS		SWITCH		HELPER
#												                PORT	PORT(S)		DEST		LIMIT		GROUP

ACCEPT		sql:10.120.0.13     fw:10.120.0.1			                    udp	    ntp,domain
ACCEPT		sql:10.120.0.113    fw:10.120.0.1			                    udp	    ntp,domain
ACCEPT		sql:10.120.0.213    fw:10.120.0.1			                    udp	    ntp,domain

# DNS: ACCEPT FROM MYSQL HOSTS TO DNS
ACCEPT		sql:10.120.0.13	    else:10.110.0.51                            udp	    53
ACCEPT		sql:10.120.0.113	else:10.110.0.51                            udp	    53
ACCEPT		sql:10.120.0.213	else:10.110.0.51                            udp	    53

# Accept mysql hosts to get updates
ACCEPT		sql:10.120.0.13	    else:10.110.0.110                            tcp	    80
ACCEPT		sql:10.120.0.113	else:10.110.0.110                            tcp	    80
ACCEPT		sql:10.120.0.213	else:10.110.0.110                            tcp	    80