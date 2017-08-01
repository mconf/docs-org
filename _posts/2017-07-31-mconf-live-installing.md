---
date: 2017-01-31
title: Installing Mconf-Live
categories:
  - Mconf-Live
  - Installation
description: How to install Mconf-Live
type: Document
---

## Requirements

* You must install it in a **fresh** Ubuntu Server 14.04 LTS **64 bits** installation. It won't work on any other linux distributions or Ubuntu versions;
* The server must be dedicated to host the Mconf Node (it can be a VPS);
* The minimum hardware requirements are: 4 cores (real or virtual CPUs) (8 is better), 4GB of RAM memory and 100GB of disk;
* The server must be connected to a high-speed network (at least symmetric 20Mbps is recommended);
* Be sure that you have opened for external access the ports TCP 80 (HTTP), TCP 443 (HTTPS), TCP 9123 (Desktop Sharing), TCP 1935 (RTMP), UDP 5060 (SIP), UDP 16384-32768 (RTP), TCP 5066 (WS), TCP 7443 (WSS);
* The server must have full access to the Internet (no outgoing firewall) - it means that the server must be able to connect in any port on remote sites;
* Your server must answer ICMP (Ping), which is used to check if your server is UP or DOWN;
* If you intend to use a domain name (like "mconf.org"), set that up before continuing;
* Set the server hostname properly (as described on next section);
* Set up the NTP service properly ([see this link](http://articles.slicehost.com/2010/11/8/using-ntp-to-sync-time-on-ubuntu));

## Installation instructions

See <https://github.com/mconf-cookbooks/mconf-live-solo>
