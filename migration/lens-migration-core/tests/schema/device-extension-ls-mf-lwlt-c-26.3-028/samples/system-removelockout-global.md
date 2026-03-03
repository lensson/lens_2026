This macro handles the ability of an administrator to remove system from lockout .

Pre-condition:

* Administrator can remove a system from lockout. It can happens as long as administrator is still connected. In this case he is able to remove global lockout.
* Users belonging to admin group will be have a special handling in global lockout. They are handled as group based, i.e. there are only two attempts allowed from users belonging to admin group, to login. If these attempts fail, then all the users of admin group are locked out.

