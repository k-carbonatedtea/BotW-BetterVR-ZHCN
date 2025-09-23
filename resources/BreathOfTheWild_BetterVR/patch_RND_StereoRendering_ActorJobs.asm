[BetterVR_StereoRendering_ActorJobs_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

; ======================================================

0x037A5DB0 = real_actor_job0_1:

hook_actor_job0_1:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job0_1@ha
addi r3, r3, real_actor_job0_1@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job0_1
blr

0x03795750 = lis r27, hook_actor_job0_1@ha
0x03795760 = addi r27, r27, hook_actor_job0_1@l

; ======================================================

0x037A7D3C = real_actor_job0_2:

hook_actor_job0_2:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job0_2@ha
addi r3, r3, real_actor_job0_2@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job0_2
blr

0x0379575C = lis r25, hook_actor_job0_2@ha
0x03795768 = addi r25, r25, hook_actor_job0_2@l

; ======================================================

0x037A6EC4 = real_actor_job1_1:

hook_actor_job1_1:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job1_1@ha
addi r3, r3, real_actor_job1_1@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job1_1
blr

0x03795834 = lis r25, hook_actor_job1_1@ha
0x03795840 = addi r25, r25, hook_actor_job1_1@l

; ======================================================

0x037A7CB8 = real_actor_job1_2:

hook_actor_job1_2:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job1_2@ha
addi r3, r3, real_actor_job1_2@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job1_2
blr

0x03795844 = lis r20, hook_actor_job1_2@ha
0x03795850 = addi r20, r20, hook_actor_job1_2@l

; ======================================================

0x037A7438 = real_actor_job2_1_ragdoll_related:

hook_actor_job2_1_ragdoll_related:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job2_1_ragdoll_related@ha
addi r3, r3, real_actor_job2_1_ragdoll_related@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job2_1_ragdoll_related
blr

0x037958F8 = lis r20, hook_actor_job2_1_ragdoll_related@ha
0x03795904 = addi r20, r20, hook_actor_job2_1_ragdoll_related@l

; ======================================================

0x037A7E30 = real_actor_job2_2:

hook_actor_job2_2:
lis r12, currentEyeSide@ha
lwz r12, currentEyeSide@l(r12)
cmpwi r12, 1
beqlr

lis r12, real_actor_job2_2@ha
addi r12, r12, real_actor_job2_2@l
mtctr r12
bctr ; ba real_actor_job2_2
blr

0x03795908 = lis r19, hook_actor_job2_2@ha
0x03795914 = addi r19, r19, hook_actor_job2_2@l

; ======================================================

0x037A7C00 = real_actor_job4:

hook_actor_job4:
mr r0, r3

lis r3, currentEyeSide@ha
lwz r3, currentEyeSide@l(r3)
cmpwi r3, 1
bne .+0x0C ; don't early return if left eye
mr r3, r0
blr

lis r3, real_actor_job4@ha
addi r3, r3, real_actor_job4@l
mtctr r3
mr r3, r0
bctr ; ba real_actor_job4
blr

0x037959C0 = lis r21, hook_actor_job4@ha
0x037959D0 = addi r21, r21, hook_actor_job4@l