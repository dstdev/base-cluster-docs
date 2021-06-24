# Login Nodes

Opening an [SSH connection](#ssh) to {{cluster_name|capitalize}} systems results in a
connection to a login node. Typically systems will have multiple login
nodes which sit behind a load balancer. New connections will be
assigned a random node. If an account has recently connected the load
balancer will attempt to connect to the same login node as the
previous connection.

## Connect to {{cluster_name|capitalize}}

To access {{cluster_name|capitalize}} via `ssh` you can do the following: 

```
   ssh <user>@{{login_node}}
```

If you have configured [sshproxy](mfa.md#sshproxy) then you can run the following:

```
   ssh -i ~/.ssh/{{cluster_name}} <user>@{{login_node}}
```

This assumes your identity file is in `~/.ssh/nersc`. The sshproxy route will be 
convenient if you have multiple ssh connections to Cori without having to 
authenticate every time.

### X11 Forwarding

X11 forwarding allows one to display remote computer to your local machine, this 
can be done as follows:

```shell
   ssh -X <user>@cori.nersc.gov
``` 

Alternatively, you can make this change persistent by adding the following line in 
`$HOME/.ssh/config`:

```
ForwardX11 yes
```

## SSH

All NERSC computers (except HPSS) are reached using either the Secure
Shell (SSH) communication and encryption protocol (version 2) or by
Grid tools that use trusted certificates.

The Secure Shell (SSH) Protocol is a protocol for secure remote login and other
secure network services over an insecure network.  The protocol is defined by
[IETF](https://www.ietf.org) RFCs [4251](https://tools.ietf.org/html/rfc4251),
[4252](https://tools.ietf.org/html/rfc4252),
[4253](https://tools.ietf.org/html/rfc4253), and
[4254](https://tools.ietf.org/html/rfc4254). Among the most widely used
implementations of SSH is [OpenSSH](https://www.openssh.com).

## Connecting to Cori with SSH

On a system with an SSH client installed, one can log into the Cori login nodes
by running the following command:

```console
ssh <username>@cori.nersc.gov
```

If the user has generated a temporary SSH key using
[`sshproxy`](../mfa/#sshproxy), then this command will connect the user to one
of Cori's login nodes. If the user has not generated a temporary SSH key, then
SSH will challenge the user for their [Iris](../../iris/iris-for-users)
password as well as their [one-time password
(OTP)](../mfa#configuring-and-using-an-mfa-token) before connecting them to a
login node.

Users are strongly encouraged to use the most up-to-date versions of SSH
clients that are available.

## Password-less logins and transfers

Consult the documentation on using the
[SSH Proxy](../mfa/#mfa-for-ssh-keys-sshproxy) service in the MFA
documentation section for ways to connect to NERSC systems without reentering
your password and one-time password.

## SSH certificate authority

NERSC generates SSH certificates for the primary login nodes using a NERSC
SSH certificate authority.  Most recent ssh clients support these certificates.
You can add the following entry to the `known_hosts` file to make use of
this certificate.

```
@cert-authority *.nersc.gov ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2yKBpvRbdD9MWiu+7wg17vBsKy46AjjuL27DmdpDYiCqRE2mN0om9b0jn4eI91RGykbcRa9wUKJ2qaD0zsD08A8HM+R14H4UsZ5hi7S+xGqscJH7uTmXy5Igo5xEOahS9Z+ecgonDCgWKJnbd/FRu4vITYXrvTlIIGHGRBYj0GzbgLHBzedoMaGNRwhVyadH2SGRaZCgbH+Swevzy0GwYfZJA9zd7EX0jiAClkSYcflIOsygmI3gHv+b35mrvXcHDeQOR/wg8knfpSiFLCkVDpfgnj27Lemzxe6k61Brhv9CUiq+t7WApVDBovhdXZn6pBg+OKeDk1G1OLvRbxJ2bw==
```

## Key fingerprints

NERSC may occasionally update the host keys on the major systems.  Check here
to confirm the current fingerprints.

### Cori
 
```
4096 SHA256:35yiNfemgwzHCHFrPGWrJBCCqERqLtOVSrR36s1DaPc cori.nersc.gov (RSA)
```

### DTN[01-04]

All of the dtn nodes should have the same fingerprints:
	
```
2048 SHA256:/cIQwTFd8zgeZKVdzE5Jqscu3IX3mRBn7ikaAGH5h6k dtn01.nersc.gov (RSA)
256 SHA256:tIO6fLqc2dHa1o3IGmWA5mtxqOURTlxHm3E6lV9zIGg dtn01.nersc.gov (ECDSA)
256 SHA256:wirBRUHXris8lXH856CnJMg6JFO2zSWqogXsDmZnZo8 dtn01.nersc.gov (ED25519)
```
	
### NoMachine/NX

```
SHA256 E7 1D 95 A6 9D B4 A4 99 5B 1A 77 8E 2C FD CF FF D3 5E ED 32 BC 63 9E EB A4 46 F1 76 0F 66 49 23 nxcloud01.nersc.gov (RSA)
SHA256 E3 2B 16 1A 97 39 02 FA D0 A8 D8 78 CD F7 EE DB 15 F3 90 B3 55 B5 A9 1F A0 6A F0 F7 E7 68 57 16  nxcloud01.nersc.gov (ECDSA)
SHA256 98 C7 54 41 60 76 9B 71 33 D3 B0 43 11 0B C0 D6 9A 70 8F C9 D7 4C FA AE D9 72 48 88 90 86 24 AD nxcloud01.nersc.gov (ED25519)
```

!!! note
    The ssh fingerprints can be obtained via:
    
    ```
    ssh-keygen -lf <(ssh-keyscan -t rsa,ed25519,ecdsa $hostname 2>/dev/null)
    ```
    
!!! note 

    Depending on the ssh client you use to connect to NERSC systems, you may see different key fingerprints. 
    For example, Putty uses different format of fingerprints as follows:

    * Cori
    
    ```
    ssh-rsa 4096 f6:36:aa:ed:60:9c:d5:f1:29:af:35:81:58:f6:26:45
    ```

    * DTN[01-04]
    
    ```
    ssh-ed25519 256 09:11:1a:d7:fc:d9:db:cb:11:c2:ea:6e:61:96:c3:3e
    ```
    
    You may see the following warning when connecting to Cori with Putty, but it is safe to ingore.
 
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

### Cori

```
cori.nersc.gov ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsxGw19ZL8EN+NZ9HhD+O/nATuvgZxcEuy/yXnGqz5wMzJj6rK7TsrdU8rdJNrhZDe3yjpCiKvqkbSKp22jK2/iMAeWDQvYpMgC6KyiNd0hztowtMFJEwb8gVmtkVioqIaf9ufJnOO0LX5A5J/4fQhICfbyPiX8SsjX0p655/kIm3T6hr7t89b4IkRu19/uWufbNaV/mZSFWl7asLKXJNTMhzEn6bsTcAqlm55Tp4NvCe1hvv6OY/vU5luDz09UDmnDfr/uukmVm5aIjtlZBGqbOe7huNJGIWhoGCN/SoArRu9T9c9fjOlRMOHcf0QYMQmxFQnR0TkJZQoJ5N+EYNUIB9dvnJs2mlN0ZEuUU0RwAUOge7RwujiZ2AWp/dV/PNvLGmDVUxiyXC0Uuw57Ga2e49hYisYU/J/NPp9AbHqO8M6kZqYdqWKYueIsM3FDti3vUbjV4J6sL6mOBbxuJpUhUEX5UXxGbR39hDVx9Lsj4dszu+mcBFnDNcpRCDjw3z+hDqdNNpzhIRlbHQErLBWL3vnn2MLnb/3z163gyRtu1iTuR5myBIs9jLDAsX94VbBzKWdCFe22x4Eo6HwB6u+UHlXov0fnBXtAmgwRegc1gQwxi2FXB/ty0q1EO+PYo3fjUVRRb4uqBBIvpFarwtL0T6iYAYgHY11vH9Z2BFAHQ==
```

## Troubleshooting

### "Access Denied", "Permission Denied" or "Too many authentication failures"

This is likely a username or password problem.

1. Make sure you are using the proper NERSC user name.
1. Log into [Iris](https://iris.nersc.gov) to clear login failures.

!!! note
    If you are using PuTTY or MobaXterm, 
    please also check the status of Cori on our [MOTD](https://www.nersc.gov/live-status/motd/) page. 
    These windows ssh clients are known to not display pre-authentication banners which NERSC uses to indicate down status.

!!! note
	If you are still unable to login, contact NERSC Account Support at
	[accounts@nersc.gov](mailto:accounts@nersc.gov).

### Host authenticity

This message may appear when a connection to a new machine is first
established:

```
The authenticity of host 'cori.nersc.gov' can't be established.
RSA key fingerprint is <omitted>
Are you sure you want to continue connecting (yes/no)?
```

1. Check that the fingerprints match
   the [list above](#key-fingerprints).
1. If they match accept
1. If they do not match [let us know](https://help.nersc.gov).

### Host identification changed

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @
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

Some users experience their SSH or Globus connections to NERSC systems
disconnect periodically and somewhat randomly. One cause of this is due to a
user's SSH client using [jumbo Ethernet
frames](https://en.wikipedia.org/wiki/Jumbo_frame), while a network switch or
router between the user's computer and the NERSC network is configured not to
forward jumbo frames, e.g., a home WiFi router or a router maintained by an
institution's IT division.

Users who experience intermittent failures of their SSH connections to NERSC
systems are encouraged to read [this ESnet
page](https://fasterdata.es.net/network-tuning/mtu-issues/debugging-mtu-problems/)
which describes the jumbo frame problem in detail and provides instructions for
diagnosing the issue.

### Other SSH connection failures

If users encounter unexpected failure when attempting to establish SSH
connections to NERSC systems, they are encouraged to collect verbose output
from the SSH client where possible, and provide that output in a ticket
submitted via the [NERSC Help Portal](https://help.nersc.gov). If using a
variant of OpenSSH, verbose output can be obtained by adding the `-vvv` flag to
the `ssh` command. Other SSH clients may have other ways of emitting verbose
output, and users are encouraged to consult the relevant documentation for
obtaining such output.

