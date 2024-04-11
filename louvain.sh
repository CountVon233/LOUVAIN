
echo -e "\n Executing louvain.sh...\n"
# ipath=../dataset/graph
# opath=../dataset/graph

# python3 /mnt/data/nfs/yusong/code/SumInc/expr2/sh/gen_inc2.py /mnt/data/nfs/yusong/dataset/large/soc-twitter/soc-twitter.e 0.0001 -w=0 

# name=test
name=LiveJournal
# name=uk2002
# name=uk2005
# name=europe_osm
# name=web-uk-2005
percentage=0.0000 # 0.3000 0.4000
max_comm_size=5000
max_level=2
beta=0.80
root_path=/home/countvon/repo/code/LOUVAIN
# inc
ipath=${root_path}/dataset/${name}/${name}.base
opath=${root_path}/dataset/louvain_bin/${name}/${name}
# no-inc
# ipath=${root_path}/dataset/large/${name}/${name}.e
# opath=${root_path}/dataset/louvain_bin/${name}

echo ipath=${ipath}
echo opath=${opath}

louvain_path=${root_path}

# 1.格式转换
${louvain_path}/convert -i ${ipath} -o ${opath}.bin
echo "-------------------------------------"

# 2.社区发现
cmd="${louvain_path}/louvain ${opath}.bin -l -1 -v -q 0 -e 0.001 -a ${max_level} -m ${max_comm_size} > ${opath}.tree"  # q=0: modularity, q=10: suminc
echo $cmd
eval $cmd
echo "-------------------------------------"

# exit

# 显示树状结构信息（层级数级别和每个级别的节点）
${louvain_path}/hierarchy ${opath}.tree
# # 显示给定级别的节点对社区的归属哪个树
level=`expr ${max_level} - 1`
echo level=$level
${louvain_path}/hierarchy ${opath}.tree -l ${level} > ${opath}_node2comm_level
echo "-------------------------------------"

#--------------------------------------------------------------------------------------------
# 为SumInc提供超点数据
# echo ${louvain_path}/getSpNode.cc
# g++ ${louvain_path}/tools/getSpNode.cc -o ${louvain_path}/tools/getSpNode
# cmd="${louvain_path}/tools/getSpNode ${opath}_node2comm_level ${ipath}"
# echo $cmd
# eval $cmd
# echo "-------------------------------------"

#---------------------------------------------------------------------------------------------
# ./matrix ${path}.tree -l ${level} > ${path}_X_level${level}
# cmd="mpirun -n 1 ${root_path}/code/SumInc/build/ingress -application pagerank -vfile /home/yusong/dataset/${name}/${name}.v -efile ${ipath} -directed=1 -cilk=true -termcheck_threshold 1 -app_concurrency 1 -compress=1 -portion=1 -min_node_num=5 -max_node_num=1003 -sssp_source=16651563 -compress_concurrency=1 -build_index_concurrency=52 -compress_type=2 -serialization_prefix ${root_path}/ser"  # 阈值1，提前收敛
# echo $cmd
# eval $cmd