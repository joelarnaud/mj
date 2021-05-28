Détail d'utilisation
====================

Ce service déploie un daemonset `aws-efs-csi-driver`_ qui permets le montage de volumes AWS EFS par le biais de
persistent volume et volume claim. Ces mount sont effectué dans les containers.

Voici un exemple de manifest qui consomme un volume EFS :

.. code-block:: bash
        :caption: Module scs_eks_csi_detail
        :name: Module scs_eks_csi_detail

            apiVersion: v1
            kind: PersistentVolume
            metadata:
              name: demo-pv
              namespace: demo
            spec:
              capacity:
                storage: 5Gi
              volumeMode: Filesystem
              accessModes:
                - ReadWriteMany
              persistentVolumeReclaimPolicy: Retain
              storageClassName: demo
              csi:
                driver: efs.csi.aws.com
                volumeHandle: fs-xyz

            ---

            apiVersion: v1
            kind: PersistentVolumeClaim
            metadata:
              name: demo-claim
              namespace: demo
            spec:
              accessModes:
                - ReadWriteMany
              storageClassName: demo
              resources:
                requests:
                  storage: 2Gi

            ----

            À incorporer dans le Deployment.yaml
                ...
                volumeMounts:
                - name: persistent-storage
                  mountPath: /mnt/ssq.local/whatever
              volumes:
              - name: persistent-storage
                persistentVolumeClaim:
                  claimName: demo-claim
                ...



.. _aws-efs-csi-driver: https://github.com/kubernetes-sigs/aws-efs-csi-driver