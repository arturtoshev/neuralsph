#!/bin/bash
# run with:
# nohup bash experiments/tgv2d_gns.sh 2>&1 &

GPU=3
RLT_DIR="rlt/tgv2d_gns"

run_basic() {
    python main.py gpu=$GPU load_ckp=ckp/pretrained/gns_tgv2d/best eval.test=True mode=infer "$@"
}

run() {
    run_basic eval.infer.n_trajs=-1 eval.infer.batch_size=20 eval.n_rollout_steps=20 \
    eval.infer.metrics_stride=100 "$@"
}

run_400() {
    run_basic eval.infer.n_trajs=-1 eval.infer.batch_size=4 eval.n_rollout_steps=120 \
    eval.infer.metrics=['mse','e_kin','sinkhorn','chamfer','rho_mae','dirichlet'] \
    eval.infer.metrics_stride=10 "$@"
}

# sanity check by reproducing the original checkpoint performance
run r.variant_p=None eval.rollout_dir=${RLT_DIR}/test_val_

run_400 r.variant_p=None eval.rollout_dir=${RLT_DIR}/test_0

run_400 r.loops=1 r.acc=0.001 eval.rollout_dir=${RLT_DIR}/test_1_0001
run_400 r.loops=1 r.acc=0.002 eval.rollout_dir=${RLT_DIR}/test_1_0002
run_400 r.loops=1 r.acc=0.005 eval.rollout_dir=${RLT_DIR}/test_1_0005
run_400 r.loops=1 r.acc=0.01 eval.rollout_dir=${RLT_DIR}/test_1_001
run_400 r.loops=1 r.acc=0.02 eval.rollout_dir=${RLT_DIR}/test_1_002
run_400 r.loops=1 r.acc=0.03 eval.rollout_dir=${RLT_DIR}/test_1_003
run_400 r.loops=1 r.acc=0.05 eval.rollout_dir=${RLT_DIR}/test_1_005

run_400 r.loops=3 r.acc=0.02 eval.rollout_dir=${RLT_DIR}/test_3_002
run_400 r.loops=5 r.acc=0.02 eval.rollout_dir=${RLT_DIR}/test_5_002
run_400 r.loops=7 r.acc=0.02 eval.rollout_dir=${RLT_DIR}/test_7_002
run_400 r.loops=10 r.acc=0.02 eval.rollout_dir=${RLT_DIR}/test_10_002

run_400 r.loops=5 r.acc=0.02 r.visc=0.1 eval.rollout_dir=${RLT_DIR}/test_5_002_01
run_400 r.loops=5 r.acc=0.02 r.visc=0.2 eval.rollout_dir=${RLT_DIR}/test_5_002_02
run_400 r.loops=5 r.acc=0.02 r.visc=0.5 eval.rollout_dir=${RLT_DIR}/test_5_002_05
run_400 r.loops=5 r.acc=0.02 r.visc=1.0 eval.rollout_dir=${RLT_DIR}/test_5_002_10
