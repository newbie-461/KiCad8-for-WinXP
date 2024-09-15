; won't work
; progwrp.dll by win32ss/supermium project

; #########################################################################
    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive
    assume fs:nothing
; #########################################################################

    include \masm32\include\windows.inc
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc

    ;includelib \masm32\lib\user32.lib
    ;includelib \masm32\lib\kernel32.lib

; #########################################################################

.code

; ##########################################################################

TLSInit_DllMain_ProcessAttach proc
	push edi
	mov edi,dword ptr ss:[esp+8]
	test edi,edi
	je @L00000008
	push ebp
	mov ebp,dword ptr fs:[18h]
	push esi
call GetVersion
	cmp al,6
	jnb short @L00000007
call GetVersion
	cmp al,6
	jnb short @L00000001
	mov eax,dword ptr ss:[ebp+30h]
	cmp dword ptr ds:[eax+30h],1
	je short @L00000007

@L00000001:
	mov eax,dword ptr ds:[edi+3Ch]
	mov ecx,dword ptr ds:[eax+edi+0C0h]
	lea eax,dword ptr ds:[ecx+edi]
	neg ecx
	sbb ecx,ecx
	and ecx,eax
	je short @L00000007
	mov esi,dword ptr ds:[ecx+0Ch]
	push ebx
	mov ebx,dword ptr ds:[ecx+8]
	cmp dword ptr ds:[ebx],0
	jnz short @L00000006
	mov ecx,dword ptr ss:[ebp+2Ch]
	test ecx,ecx
	je short @L00000003
	mov eax,dword ptr ds:[ecx]
	test eax,eax
	je short @L00000003
	xor edx,edx

@L00000002:
	test al,3
	jnz short @L00000003
	add ecx,4
	inc edx
	mov dword ptr ds:[ebx],edx
	mov eax,dword ptr ds:[ecx]
	test eax,eax
	jnz short @L00000002

@L00000003:
	test esi,esi
	je short @L00000005
	mov eax,dword ptr ds:[esi]
	test eax,eax
	je short @L00000005

@L00000004:
	push 0
	push 1
	push edi
	call eax
	mov eax,dword ptr ds:[esi+4]
	lea esi,dword ptr ds:[esi+4]
	test eax,eax
	jnz short @L00000004

@L00000005:
	push edi
	call TLSInit_DllMain_ThreadAttach

@L00000006:
	pop ebx

@L00000007:
	pop esi
	pop ebp

@L00000008:
	pop edi
	retn 4

TLSInit_DllMain_ProcessAttach endp



TLSInit_DllMain_ThreadAttach proc 

	push esi
	mov esi,dword ptr ss:[esp+8]
	test esi,esi
	je @L00000016
	push ebp
	mov ebp,dword ptr fs:[18h]
	push edi
call GetVersion
	cmp al,6
	jnb @L00000015
call GetVersion
	cmp al,6
	jnb short @L00000009
	mov eax,dword ptr ss:[ebp+30h]
	cmp dword ptr ds:[eax+30h],1
	je @L00000015

@L00000009:
	mov eax,dword ptr ds:[esi+3Ch]
	mov edi,dword ptr ds:[eax+esi+0C0h]
	lea eax,dword ptr ds:[edi+esi]
	neg edi
	sbb edi,edi
	and edi,eax
	je @L00000015
	mov esi,dword ptr ss:[ebp+2Ch]
	push ebx
	mov ebx,dword ptr ds:[edi+8]
	mov eax,dword ptr ds:[ebx]
	cmp dword ptr ss:[ebp+44h],eax
	jnb @L00000014
	mov dword ptr ss:[ebp+44h],eax
	mov eax,dword ptr ds:[ebx]
	lea eax,dword ptr ds:[eax*4+8]
	push eax
	mov eax,dword ptr ss:[ebp+30h]
	push 8
	push dword ptr ds:[eax+18h]
call HeapAlloc
	mov edx,eax
	mov dword ptr ss:[esp+14h],edx
	test esi,esi
	je short @L00000012
	xor ecx,ecx
	cmp dword ptr ds:[ebx],ecx
	jbe short @L00000012
	nop

@L00000010:
	test ecx,ecx
	jnz short @L00000011
	mov eax,dword ptr ds:[esi]
	mov dword ptr ds:[eax+8],ecx

@L00000011:
	mov eax,dword ptr ds:[esi+ecx*4]
	mov dword ptr ds:[edx+ecx*4],eax
	inc ecx
	cmp ecx,dword ptr ds:[ebx]
	jb short @L00000010

@L00000012:
	mov eax,dword ptr ds:[edi+4]
	sub eax,dword ptr ds:[edi]
	push eax
	mov eax,dword ptr ss:[ebp+30h]
	push 8
	push dword ptr ds:[eax+18h]
call HeapAlloc
	mov ecx,dword ptr ds:[ebx]
	mov edx,dword ptr ss:[esp+14h]
	mov dword ptr ds:[edx+ecx*4],eax
	mov eax,dword ptr ds:[ebx]
	mov dword ptr ds:[edx+eax*4+4],0ABABABABh
	mov ecx,dword ptr ds:[edi]
	mov eax,dword ptr ds:[edi+4]
	sub eax,ecx
	push eax
	mov eax,dword ptr ds:[ebx]
	push ecx
	push dword ptr ds:[edx+eax*4]
call RtlMoveMemory
	test esi,esi
	je short @L00000013
	mov eax,dword ptr ss:[ebp+30h]
	push esi
	push 0
	push dword ptr ds:[eax+18h]
call HeapFree

@L00000013:
	mov eax,dword ptr ss:[esp+14h]
	mov dword ptr ss:[ebp+2Ch],eax

@L00000014:
	pop ebx

@L00000015:
	pop edi
	pop ebp

@L00000016:
	pop esi
	retn 4

TLSInit_DllMain_ThreadAttach endp

DllMain proc  hInstDLL:DWORD, reason:DWORD, unused:DWORD
mov eax, [esp+8]
cmp eax, DLL_PROCESS_ATTACH
jne @2
mov eax, [esp+4]
push eax
call TLSInit_DllMain_ProcessAttach
@2:
mov eax, 1
retn 0ch
DllMain endp

; ##########################################################################
end