# Login Nodes

Opening an [SSH connection](#ssh) to {{cluster_name|capitalize}} systems results in a
connection to a login node. Typically systems will have multiple login
nodes which sit behind a load balancer. New connections will be
assigned a random node. If an account has recently connected the load
balancer will attempt to connect to the same login node as the
previous connection.

## Connect to {{cluster_name|capitalize}}







## SSH


The Secure Shell (SSH) Protocol is a protocol for secure remote login and other
secure network services over an insecure network.  The protocol is defined by
[IETF](https://www.ietf.org) RFCs [4251](https://tools.ietf.org/html/rfc4251),
[4252](https://tools.ietf.org/html/rfc4252),
[4253](https://tools.ietf.org/html/rfc4253), and
[4254](https://tools.ietf.org/html/rfc4254). Among the most widely used
implementations of SSH is [OpenSSH](https://www.openssh.com).


On a system with an SSH client installed, one can log into the Cori login nodes
by running the following command:

```console
```

If the user has generated a temporary SSH key using
[`sshproxy`](../mfa/#sshproxy), then this command will connect the user to one
of Cori's login nodes. If the user has not generated a temporary SSH key, then
SSH will challenge the user for their [Iris](../../iris/iris-for-users)
password as well as their [one-time password
## Password-less logins and transfers

Consult the documentation on using the
[SSH Proxy](../mfa/#mfa-for-ssh-keys-sshproxy) service in the MFA
documentation section for ways to connect to NERSC systems without reentering
your password and one-time password.

## SSH certificate authority


```

## Key fingerprints


 
```
```

	
```
```
	


!!! note
    The ssh fingerprints can be obtained via:
    
    ```
    ssh-keygen -lf <(ssh-keyscan -t rsa,ed25519,ecdsa $hostname 2>/dev/null)
    ```
    
    PuTTY Security Alert
    The server's host key is not cached in the registry. You have no guarantee that the server is the computer you think it is.
    The server's rsa2 key fingerprint is:
    ssh-rsa 4096 f6:36:aa:ed:60:9c:d5:f1:29:af:35:81:58:f6:26:45
    If you trust this host, hit Yes to add the key to PuTTY's cache and carry on connecting.
    If you want to carry on connecting just once, without adding the key to the cache, hit No.
    If you do not trust this host, hit Cancel to abandon the connection.
    
    ``` 

## Host Keys

These are the entries in `~/.ssh/known_hosts`.


## Troubleshooting





### "Access Denied", "Permission Denied" or "Too many authentication failures"






### Host authenticity


```


### Host identification changed

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
...
```

Ensure that your `~/.ssh/known_hosts` file contains the correct entries for
Cori and confirm the fingerprints using the posted fingerprints above.  Add the
[certificate authority](#ssh-certificate-authority) line to your known_hosts
file if you version of ssh supports SSH certificates.

1. Open `~/.ssh/known_hosts`
1. Remove any lines referring Cori and save the file
1. Paste the host key entries from above or retry connecting to the host and
   accept the new host key after verify that you have the correct "fingerprint"
   from the above list.

### SSH connection disconnects periodically


### Other SSH connection failures


