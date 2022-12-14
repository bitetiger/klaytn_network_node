# Klaytn Network Node (Servicechain & Endpoint)
![image](https://user-images.githubusercontent.com/89952061/192130689-5ba561d5-55eb-4aa3-9ae6-fb5fb2556748.png)
### project goals
높은 TPS와 낮은 수수료 등 서비스 제공을 위한 klaytn Layer 2인 **Service chain 노드**와 klaytn 메인넷의 인터페이스인 **Endpoint 노드**를 주어진 요구조건에 맞춰 구축합니다.

### requirements
  - Klaytn 네트워크
  - 블록체인 네트워크 모니터링툴, IaC, CI/CD 시스템 구축, 오픈소스 활용
  - Sevice Management, Monitoring/Alerting, Security, Automation, Configuration Management 다양한 관점 고려

## Description
효율적인 블록체인 노드 운영을 위해서는 **빠른 인프라 구축**과 **모니터링을 통한 안정적인 운영**, **간편한 구성관리와 프로비저닝**이 요구됩니다. 이 세 가지를 중점으로 프로젝트를 진행했습니다.

### built with
- **AWS** : EC2, EBS, VPC, Subnet, Nat gateway 등 서버와 네트워크 구축, 보안을 위해 AWS 클라우드 리소스를 활용합니다.  

- **Terraform** : 코드를 통해 노드 구축에 요구되는 AWS 인프라를 빠르게 구성하고 효율적으로 관리할 수 있습니다. Terraform을 통해 아래와 같이 리소스 구성과 환경구성이 완료됩니다. 
  - [x] EC2, VPC, Subnet, Nat gateway, Security Group 등 아키텍처 전반의 인프라 구성 완료
  - [x] Service chain node, Endpoint node 구성을 위한 패키지(kscn, homi, ken) 설치 완료
  - [x] Service chain node 설정을 위한 genesis.json, nodekey 파일 생성 완료
  - [x] Endpoint node의 genesis.json 생성 및 노드 초기화 완료 
  - [x] 환경 구성를 위한 Ansible 설치 및 AWS EC2 Dynamic Inventory와 ping test를 위한 Playbook 생성 및 설정 완료
  - [x] 모니터링을 위한 Grafana 설치 및 가동 완료
- **Grafana** : 다양한 클라우드 리소스의 메트릭/로그 시각화와 알림을 통해 안정적인 노드 모니터링을 지원합니다. Grafana-EC2 서버를 통해서 운영됩니다. public_dns:3000을 브라우저를 통해 접속 시 대시보드 확인이 가능합니다.
- **Ansible** : AWS 환경에서 EC2의 Dynamic inventory 생성이 가능하여 노드의 업데이트와 구성관리, 프로비저닝이 가능합니다. Ansible_master 서버를 통해서 운영됩니다.

## Resource
![image](https://user-images.githubusercontent.com/89952061/192152887-4922f3f0-45e1-4d4a-b5e8-bd33fe143bef.png)
### Service chain node
서비스 체인 운영을 위해 SCN-master, SCN-1, SCN-2, SCN-3로 총 4개의 노드가 가동됩니다. SCN-master는 서비스 체인의 데이터 앵커링과 체인간 토큰 전송을 위해 Endpoint node의 브릿지 역할을 수행합니다. 서비스 체인의 보안을 위해 private subnet에 구축되었으며, Endpoint node가 서비스 체인에 접속할 수 있는 bastion host입니다.
* EC2 : Ubuntu 22.04 LTS, t2.large
* Private subnet

### Endpoint node
EN-node 1개가 운영되며 klaytn 블록체인 데이터를 동기화하고 받은 블록을 검증합니다. Endpoint node는 Private subnet에 위치한 ansible 서버와 Service chain node의 bastion host이며, SCN-master 노드와 1:1로 연결됩니다.
* EC2 : Ubuntu 22.04 LTS, t2.large
* EBS : 200 GiB
* Public subnet

### Ansible Server (Configuration Management)
Ansible_master 서버는 AWS에서 가동되는 모든 EC2를 자동으로 등록하여 노드의 상태 확인 및 간편한 환경설정과 프로비저닝이 가능합니다. 전체 노드를 컨트롤하는 만큼 Private subnet에 설치하여 외부의 접근이 불가능합니다.
* EC2 : Ubuntu 22.04 LTS, t2.medium
* Private subnet

### Grafana Server (Monitoring)
Grafana-EC2 1개로 운영되며 AWS Cloud watch 플러그인을 통해서 클라우드 리소스의 메트릭/로그를 시각화합니다. 노드들의 CPU utilization, 네트워크 현황과 상태 체크 등을 확인할 수 있습니다. 브라우저를 통해 모니터링 서버에 접속할 수 있어야하기 때문에 Endpoint server와 public subnet 구성을 달리하였습니다.
* EC2 : Ubuntu 22.04 LTS, t2.micro
* Public subnet

### CloudWatch
Cloudwatch Alert 기능을 활용하여 노드의 CPU utilization가 상태 검사를 체크하고 확인합니다. 일정 기준을 초과한 경우, 지정된 SNS 주제로 경보 메시지 전달과 조치를 취합니다.  
- CPU utilization이 일정기준 초과 시, 지정 SNS로 경보 메시지 전달  
- 인스턴스 상태 체크 실패 시, 지정 SNS 경보 메시지 전달 및 인스턴스 재부팅

## Get started
1) Terraform을 사용하여 AWS의 전체 인프라 리소스 생성
2) 노드와 특정 서버들의 환경설정 진행

### Service chain node
1) Endpoint 노드를 통해서 노드 우회 접속
2) https://ko.docs.klaytn.foundation/node/service-chain/getting-started/4nodes-setup-guide 2단계의 static-nodes.json 파일 수정 (모두 22323 port로 지정)
3) ```$ scp -r -i {key-name.pem} ~/homi-linux-amd64/bin/homi-output/ {user}@{ip_address}:~/``` homi-output 파일을 scn-1, scn-2, scn-3에 전송
4) ```$ kscn --datadir ~/data init ~/homi-output/scripts/genesis.json``` 노드 초기화 
5) ```$ cp ~/homi-output/scripts/static-nodes.json ~/data/``` static-nodes.json 파일을 data 폴더에 복사
6) ```$ cp ~/homi-output/keys/nodekey{1..4} ~/data/klay/nodekey``` 각 노드에 nodekey를 data 폴더에 복사
7) kscn에서 conf/kscnd.conf 파일을 아래와 같이 수정
8) ```... PORT=22323, SC_SUB_BRIDGE=0, DATA_DIR=~/data...``` (scn-1 ~ 3)
9) ```... SC_SUB_BRIDGE=1, SC_PARENT_CHAIN_ID=1001, SC_ANCHORING_PERIOD=10, DATA_DIR=~/data ...```(scn-master)
10) ```$ kscnd start``` 노드 시작

### Endpoint node
1) ken 디렉토리에서 kend_baobab.conf 파일을 kend.conf로 수정
2) kend.conf 내용을 아래와 같이 설정 
3) ``` ... SC_MAIN_BRIDGE=1, DATA_DIR=~/data ...```
4) ```$ export PATH=$PATH:/home/ubuntu/ken-linux-amd64/bin```
5) ```$ kend start``` 노드 시작

### Ansible
1) Endpoint 노드를 통해서 Ansible 서버 우회 접속
2) ```mv ~/ansible.cfg /etc/ansible/ansible.cfg ``` ansible.cfg 이동하여 설정변경

### Grafana server
1) 해당 EC2의 Public_DNS 주소의 Port 3000번으로 Grafana 어플리케이션 접속 (id : admin, pw : admin)
2) Configuration -> Plugin -> Cloudwatch -> ```Create a CloudWatch data source``` 클릭
3) AWS Access key와 Secret key 설정을 통해서 데이터 리소스 생성
4) repo의 src/grafana_dashboard.json 을 활용해서 대시보드 

## 구현 화면
### Service chain Node
![image](https://user-images.githubusercontent.com/89952061/192149074-d1566f10-25d6-489b-b37c-45cb811f8b32.png)
SCN-master 노드에서 subbridge.peers.length 명령을 통해 SCN-master 노드와 Endpoint node가 연결이 완료된 상태인 것을 알 수 있습니다. Endpoint node를 통해서 데이터 앵커링이 가능해집니다.

![image](https://user-images.githubusercontent.com/89952061/192156725-131c6263-1c84-4c07-b2d5-63c72300f228.png)
SCN-master 노드의 kscnd.out 로그입니다. 새로운 블록이 생성되고 커밋되는 상태를 확인할 수 있습니다.

![image](https://user-images.githubusercontent.com/89952061/192149149-e15c2690-7c8e-4916-a9a7-d39274ec4f0b.png)
SCN-1 노드에서 klay.blockNumber 명령을 통해서 서비스 체인의 블록 생성이 진행되고 있는 것을 확인할 수 있습니다.

### Endpoint Node
![image](https://user-images.githubusercontent.com/89952061/192147421-a7490c4e-c930-42c4-bac3-b4cfe5ceb1e2.png)
Endpoint 노드에서 klay.blockNumber 명령으로 클레이튼 네트워크의 블록이 안정적으로 동기화되고 있는 것을 확인할 수 있습니다.

![image](https://user-images.githubusercontent.com/89952061/192156833-46c17a09-885a-43f7-bb48-3c4efd739cdf.png)
kend.out 로그를 확인하여 메인넷의 블록을 빠르게 동기화하고 있는 것을 확인할 수 있습니다.

### Ansible master
![image](https://user-images.githubusercontent.com/89952061/192151725-e46cb80f-8e4a-40b9-8ab9-f8c1dc5961bf.png)
ansible에서 AWS에서 가동 중인 EC2 서버들이 인벤토리에 동적으로 자동할당되었습니다.

### Grafana Monitoring
![image](https://user-images.githubusercontent.com/89952061/192151576-e4b33e78-34e6-4569-804f-a262b9f5f2d0.png)
주요 aws 리소스들의 메트릭/로그를 시각화한 화면입니다. 위 대시보드는 Grafana EC2의 public_dns:3000에 접속하여 확인할 수 있습니다.

### CloudWatch 
![image](https://user-images.githubusercontent.com/89952061/192171228-bbd8cfa9-aa68-4251-829c-90f0f1d1f23f.png)
가동 중인 노드들의 CPU utilization과 Instance 상태에 따라 Alert 메시지와 함께 설정된 조치가 취해집니다.
