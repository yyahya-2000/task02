;option 10 (Вариант 10)
;Ф.И.Г: Яхя Янал БПИ197 
;Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A 
;новый массив B состоит из элементов A в обратном порядке ;

format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        strVecSize   db 'size of vector? ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strValue  db 'Vector B:',10, 0
        strVecElemOut  db '[%d] = %d', 10, 0

        vec_size     dd 0
        i            dd ?
        tmp          dd ?
        vec          rd 100
        vecB         rd 100

section '.code' code readable executable

start:
; 1) vector input
        push strVecSize
        call [printf]

        push vec_size
        push strScanInt
        call [scanf]

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push [vec_size]
        push strIncorSize
        call [printf]
        jmp finish
; continue...
getVector:
        xor ecx, ecx             ; ecx = 0
        mov ebx, vec             ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]

        push ebx
        push strScanInt
        call [scanf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:


;**********************************************************************
; 2) get reverse vector
reverseVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
        mov ecx, 4              ; ecx = 4
        mov eax, [vec_size]     ; eax = vec_size
        dec eax                 ; eax = vec_size - 1
        imul ecx                ; eax = eax * ecx
        add ebx,eax             ; ebx += eax
        mov ecx, [vec_size]     ; ecx = vec_size
        mov edx, vecB           ; edx = &vecB
reverseVecLoop:

        cmp ecx, 0              ; if ecx==0
        je endreverseVec        ; to end of loop
        mov eax,[ebx]           ; eax = *ebx
        mov [edx],eax           ; edx = eax
        dec ecx                 ; ecx-= 1
        sub ebx, 4              ; ebx -= 4
        add edx,4               ; edx += 4
        jmp reverseVecLoop
endreverseVec:

;*****************************************************************
; 3) out of vectorB
         push strValue
         call [printf]

; 4) test vector out
putVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vecB            ; ebx = &vec

putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx


        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:





finish:
                call [getch]

                push 0
                call [ExitProcess]


                                

;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
