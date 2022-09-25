# klaytn Network Node (Servicechain&Endpoint)
높은 TPS와 낮은 수수료 등 서비스 제공을 위한 klaytn Layer 2인 **Service chain 노드**와 klaytn 메인넷의 인터페이스인 **Endpoint 노드**를 주어진 요구조건에 맞춰 구축합니다.
![image](https://user-images.githubusercontent.com/89952061/192130689-5ba561d5-55eb-4aa3-9ae6-fb5fb2556748.png)
### requirement
  - Klaytn 네트워크
  - 블록체인 네트워크 모니터링툴, IaC, CI/CD 시스템 구축, 오픈소스 활용
  - Sevice Management, Monitoring/Alerting, Security, Automation, Configuration Management 다양한 관점 고려

## Description
효율적인 블록체인 노드 운영을 위해서는 **빠른 인프라 구축**과 **모니터링을 통한 안정적인 운영**, **간편한 구성관리와 프로비저닝**이 요구됩니다. 이 세 가지를 중점으로 프로젝트를 진행했습니다
![image](https://user-images.githubusercontent.com/89952061/192111327-301e9d11-c4eb-47e9-8f0b-1bc31a584a61.png)

### Built With
- **AWS** : EC2, EBS, VPC, Subnet, Nat gateway 등 서버와 네트워크 구축, 보안을 위해 AWS 클라우드 리소스 활용합니다.
- **Terraform** : 코드를 통해 노드 구축에 요구되는 AWS 인프라를 빠르게 구성하고 효율적으로 관리할 수 있습니다. 아래는 Terraform을 통해 구축되는 인프라 단계입니다.

- **Grafana** : 다양한 클라우드 리소스의 메트릭/로그 시각화와 알림을 통해 안정적인 노드 모니터링을 지원합니다. Grafana-EC2 서버를 통해서 운영됩니다. pulic_dns:3000을 브라우저를 통해 접속 시 인터페이스 확인이 가능합니다.
- **Ansible** : AWS 환경에서 EC2의 Dynamic inventory 생성이 가능하여 노드의 업데이트와 구성관리, 프로비저닝이 가능합니다. Ansible_master 서버를 통해서 운영됩니다.

## Resource
### Service chain node
SCN-master, SCN-1, SCN-2, SCN-3로 총 4개
* EC2 : Ubuntu 22.04 LTS, t2.large
* Public subnet

### Endpoint node
EN-node 1개
* EC2 : Ubuntu 22.04 LTS, t2.large
* EBS : 100 GiB
* Private subnet

### Configuration Management(Ansible)
Ansible_master 서버를 통해서 AWS에서 가동되는 모든 EC2의 환경설정과 프로비저닝이 가능합니다. 가동되는 모든 노드들의 상태 확인과 더불어 효율적인 구성관리가 가능합니다.
* EC2 : Ubuntu 22.04 LTS, t2.medium
* Private subnet

### Monitoring(Grafana)
Grafana-EC2 1개
* EC2 : Ubuntu 22.04 LTS, t2.micro
* Public subnet

## Get Started
* How/where to download your program
* Any modifications needed to be made to files/folders

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)


## Test
### Endpoint Node
![image](https://user-images.githubusercontent.com/89952061/192108433-d0d77752-2f7d-4315-a321-60195c44d9cb.png)

### Service chain Node
![image](https://user-images.githubusercontent.com/89952061/192108347-ef6cf625-5b1a-4512-807c-273805ca45e9.png)
EN과 연결 확인
![image](https://user-images.githubusercontent.com/89952061/192108402-f9282ff7-0ccd-4c33-a9c8-e8497e0b08a3.png)
Layer 2의 블록 생성 확인

### Ansible master
![image](https://user-images.githubusercontent.com/89952061/192129689-1cfcecd1-4e49-4ba5-b65d-c4d827bc1c9e.png)
ansible에서 전체 ec2 노드 할당 성공
![image](https://user-images.githubusercontent.com/89952061/192130567-d7c98d5b-5d3c-496d-8643-caf916f191f5.png)
전체 ec2 노드 ping 전송 테스트 성공

### Grafana Monitoring
![image](https://user-images.githubusercontent.com/89952061/192111171-8f65b1a8-cd66-4f89-955d-7af511c8fd24.png)

