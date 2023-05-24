# Description 

This module creates a s3 bucket to store your terraform states and a dynamo tables for lock states. The s3 compartment hierarchy is organised for managing elasticbeanstalk applications:

```sh
➜  s3-bucket-name tree .
.
├── elasticbeanstalk-app1
│   ├── dev
│   │   └── tf.state
│   └── prod
│       └── tf.state
└── elasticbeanstalk-app2
    ├── dev
    │   └── tf.state
    └── prod
        └── tf.state

7 directories, 4 files
```
