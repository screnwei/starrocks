#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e

ROOT=`dirname "$0"`
ROOT=`cd "$ROOT"; pwd`

export STARROCKS_HOME=${ROOT}/../..

. ${STARROCKS_HOME}/env.sh

export BROKER_HOME=$ROOT/
export BROKER_CORE_HOME=$ROOT/src/broker-core/
export HADOOP_COS_HOME=$ROOT/src/hadoop-cos-shaded/

echo ${BROKER_HOME}
cd ${BROKER_HOME}/src
$MVN_CMD clean
$MVN_CMD package -DskipTests

echo "Install broker..."
BROKER_OUTPUT=${BROKER_HOME}/output/apache_hdfs_broker/
rm -rf ${BROKER_OUTPUT}

install -d ${BROKER_OUTPUT}/bin ${BROKER_OUTPUT}/conf \
           ${BROKER_OUTPUT}/lib/

cp -r -p ${BROKER_HOME}/bin/*.sh ${BROKER_OUTPUT}/bin/
cp -r -p ${BROKER_HOME}/conf/*.conf ${BROKER_OUTPUT}/conf/
cp -r -p ${BROKER_HOME}/conf/*.xml ${BROKER_OUTPUT}/conf/
cp -r -p ${BROKER_HOME}/conf/log4j.properties ${BROKER_OUTPUT}/conf/
cp -r -p ${HADOOP_COS_HOME}/target/hadoop-cos-shaded*.jar ${BROKER_OUTPUT}/lib/
cp -r -p ${BROKER_CORE_HOME}/target/lib/* ${BROKER_OUTPUT}/lib/
cp -r -p ${BROKER_CORE_HOME}/target/apache_hdfs_broker.jar ${BROKER_OUTPUT}/lib/

echo ""
echo "***************************************"
echo "**Successfully build StarRocks Broker**"
echo "***************************************"
