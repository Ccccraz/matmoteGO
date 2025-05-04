## cmdProxy examples

### Overview
```mermaid
sequenceDiagram
    matlab_listener ->> cogmoteGO: start cmdProxy
    cogmoteGO --> matlab_listener: 201
    cogmoteGO ->> matlab_listener: Handshake Hello
    matlab_listener ->> cogmoteGO: Handshake World
    matlab_sender ->> cogmoteGO: data
    cogmoteGO ->> matlab_listener: data
    matlab_listener ->> cogmoteGO: {'result': 'ok'}
    cogmoteGO --> matlab_sender: 201 {'result': 'ok'}
```

### send cmd
It involves: `sendCmd` and `waitCmd`


```mermaid
sequenceDiagram
    waitCmd ->> cogmoteGO: start cmdProxy
    sendCmd ->> cogmoteGO: cmd
    cogmoteGO ->> waitCmd: cmd
    waitCmd ->> cogmoteGO: {'result': 'ok'}
    cogmoteGO --> sendCmd: 201 {'result': 'ok'}
    waitCmd ->> waitCmd: Handle cmd
```

### send serialized object
It involves: `sendSampleData`, `waitSampleData`, `sampleData`

```mermaid
sequenceDiagram
    waitSampleData ->> cogmoteGO: start cmdProxy
    sendSampleData ->> sendSampleData: create sampleData and Serialize
    sendSampleData ->> cogmoteGO: sampleData
    cogmoteGO ->> waitSampleData: sampleData
    waitSampleData ->> cogmoteGO: {'result': 'ok'}
    cogmoteGO --> sendSampleData: 201 {'result': 'ok'}
```

### send serialized big object
It involves: `sendSampleBigData`, `waitSampleData`, `sampleBigData`

```mermaid
sequenceDiagram
    waitSampleData ->> cogmoteGO: start cmdProxy
    sendSampleBigData ->> sendSampleBigData: create sampleData and Serialize
    sendSampleBigData ->> cogmoteGO: sampleData
    cogmoteGO ->> waitSampleData: sampleData
    waitSampleData ->> cogmoteGO: {'result': 'ok'}
    cogmoteGO --> sendSampleBigData: 201 {'result': 'ok'}
```
