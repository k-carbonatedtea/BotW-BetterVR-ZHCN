[BetterVR_FirstPersonMode_V208]
moduleMatches = 0x6267BFD0

.origin = codecave

; prevents the translucent opacity to be set for the weapon (and maybe more?)
0x024A69CC = _setWeaponOpacity:
conditionalSetWeaponOpacityJump:
mflr r0
stwu r1, -0x10(r1)
stw r0, 0x14(r1)
stw r8, 0x08(r1)

li r8, $cameraMode
cmpwi r8, 1
beq exitSetWeaponOpacity

lis r8, _setWeaponOpacity@ha
addi r8, r8, _setWeaponOpacity@l
mtctr r8
bctrl

exitSetWeaponOpacity:
lwz r8, 0x08(r1)
lwz r0, 0x14(r1)
addi r1, r1, 0x10
mtlr r0
blr

0x024ae2b4 = bla conditionalSetWeaponOpacityJump

; disables more SetWeaponOpacity calls
0x02D55084 = .int ((($cameraMode == 0) * 0x4B751A55) + (($cameraMode == 1) * 0x60000000))

; disables the transition effect when an object goes out of view/near the camera
; 0x4182003C = beq 0x02D53130
; 0x60000000 = nop
0x02D530F4 = .int ((($cameraMode == 0) * 0x4182003C) + (($cameraMode == 1) * 0x60000000))

; disables the opacity fade effect when it gets near any graphics
0x02C05A2C = .int ((($cameraMode == 0) * 0x2C040000) + (($cameraMode == 1) * 0x7C042000))

; disables camera collision fading when it collides with objects
0x02C07848 = .int ((($cameraMode == 0) * 0x2C030000) + (($cameraMode == 1) * 0x2C010000))

; sets distance from the camera
customCameraDistance:
.float $cameraDistance

; original version of the camera distance mod
; 0x10216594 = .float $cameraDistance

0x02E5FEB8 = lis r9, customCameraDistance@ha
0x02E5FEC0 = lfs f13, customCameraDistance@l(r9)
