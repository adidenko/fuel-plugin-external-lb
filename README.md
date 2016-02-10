# fuel-plugin-external-lb

## Purpsoe
The main purpose of this plugin is to provide ability to use external load balancer instead of Haproxy which is deployed on controllers.

It can also allow cloud operators to move controllers into different racks (see more details below).

## Requirements
External load balancer configuration is out of scope of this plugin. We assume that you configure load balancer by other means (manually or by some other Fuel plugin).

In order to configure your load balancer properly before deployment starts, you can use deployment info provided by Fuel. So you need to:

1. Create new environment
2. Enable plugin
3. Configure your environment (assign roles, networks, adjust settings, etc)
4. Download deployment info with the following CLI command on Fuel node:
```bash
fuel deployment --env 1 --default
```
After this you can open any yaml in `./deployment_1/` directory and check controller management and public IPs in `network_metadata/nodes` hash.

If you want to Public TLS then please note that Fuel generates self-signed SSL certificate during deployment, so you can't download it before deployment starts and configure it on external load balancer. The best solution is to create your own certificate (self signed or issued) and upload it via Fuel -> Settings -> Security.

## Known limitations
* OSTF is not working
* Floating IPs are not working if controllers are in different racks

## Configuration

## How to move controllers to different racks?
In our deployment we use HA resources that are being deployed on controller nodes. Those are mostly services and VIPs.

There are no problems to provide HA for services when we deploy controllers in different racks - we use unicast, so Corosync cluster works fine and provides failover for services without problems.

Providing HA/failover for IPs is the problem here. In case of static routing it’s simply impossible to move IP from one rack to another - such IP won’t be routable anywhere outside its own rack. This problem affects VIPs (services frontends, endpoints) and Floating IPs.

### IP traffic flow chart

#### Default IP flow
![Default IP flow scheme](doc/default-traffic.png)
![Legend](doc/legend.png)

#### New IP flow with "fake floating network"
![New IP flow scheme](doc/new-traffic.png)
![Legend](doc/legend.png)
