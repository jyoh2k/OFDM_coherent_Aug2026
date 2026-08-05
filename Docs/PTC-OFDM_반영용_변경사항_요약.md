# PTC-OFDM 반영용 변경 사항 요약

**기준**: 현재 프로젝트 `OFDM_coherent_Feb2026`에서 변경된 내용  
**대상**: `Y:\Matlab\oc\PTC-OFDM_coherent_Feb2026\PTC_OFDM_coherent_09Feb2026` (PTC-OFDM)  
**용도**: 반영할 항목만 선택해 수동으로 적용할 때 참고 (코드 직접 수정 금지 지침에 따라 본 문서만 제공)

---

## 1. Receiver/ChannelEst.m

### 1.1 H 배열 차원
| 항목 | 현재 (OFDM_coherent_Feb2026) | PTC-OFDM |
|------|-----------------------------|----------|
| H 초기화 | `zeros(params.NTXStream, params.NTXStream, ...)` | `zeros(params.NRXStream, params.NTXStream, ...)` |
| ChannelEst_LTF 내부 out | `zeros(params.NTXStream, params.NTXStream, params.NFFT)` | `zeros(params.NRXStream, params.NTXStream, params.NFFT)` |

- **의미**: 현재 프로젝트는 **2×2 MIMO**(TX 2, RX 2) 가정으로 H를 (NTX×NTX)로 둠. PTC-OFDM은 **1×2**(RX 1, TX 2)라 (NRX×NTX) 사용.

### 1.2 ChannelEst_AA (2 stream 채널 추정)
| 항목 | 현재 (OFDM_coherent_Feb2026) | PTC-OFDM |
|------|-----------------------------|----------|
| RX 행 구성 | RX(1,:,:), RX(2,:,:) 둘 다 사용 (2 RX) | RX(2,:,:) 주석 처리 → **RX 1개만** 사용 |
| TX 행 구성 | `[LTF; LTF]`, `[LTF; -LTF]` | `[LTF; LTF]`, `[-conj(LTF); conj(LTF)]` (PTC 타입) |
| out 크기 | `zeros(2, 2, params.NFFT)` | `zeros(1, 2, params.NFFT)` (1×2 등화기) |
| 추정식 | `out(:,:,ii) = TX(:,:,ii) / RX(:,:,ii)` (주석: transpose(TX/RX) @org) | `out(1,:,ii) = inv(TX(:,:,ii)) * (RX(1,:,ii)).'` |
| 반환 | `out = out(:,:, params.SubcarrierIndex)` (2×2) | `out = out(1,:, params.SubcarrierIndex)` (1×2) |

- **정리**: 현재는 **2 RX·2 TX 등화기(2×2)**. PTC-OFDM은 **1 RX·2 TX**이므로 **1×2 등화기**와 PTC용 LTF 타입(`-conj(LTF); conj(LTF)`) 사용.  
  → PTC-OFDM에 현재 식을 그대로 넣으면 안 되고, “2×2 → 1×2 + PTC LTF” 구조 차이를 유지한 채로, 필요 시 **일부만** 참고해 반영.

---

## 2. Receiver/ChannelComp.m

### 2.1 전체 구조
| 항목 | 현재 (OFDM_coherent_Feb2026) | PTC-OFDM |
|------|-----------------------------|----------|
| 데이터 심볼 루프 | `for isym=1:params.NDataSymbol` (심볼 단위) | `for isym=1:2:params.NDataSymbol` (2 심볼 단위, PTC 짝/홀) |
| NDataSymbol | 그대로 사용 | `NRXStream==1 && NTXStream==2`이면 `NDataSymbol/2`로 사용 |
| 등화/복호 | `ChannelComp_1Symbol(onesymbol, H, params)` | `DEC_2Symbol(oddSymbol, evenSymbol, H, params)` (PTC 2심볼 복호) |

- **의미**: 현재는 **심볼별 1:1 등화** (H*in). PTC-OFDM은 **PTC 방식**으로 odd/even 2심볼을 묶어 `DEC_2Symbol`에서 복호.

### 2.2 현재 프로젝트에만 있는 요소
- `CPR_1Symbol`에 `acc_cpe` 인자 전달 및 `acc_cpe` 업데이트.
- `BlindCPR_1Symbol`에 `acc_cpe` 전달.
- `SFOComp_1Symbol`만 사용 (PTC 전용 `SFOComp_1Symbol_PTC` 없음).

### 2.3 PTC-OFDM에만 있는 요소 (현재 프로젝트에 없음)
- `DEC_2Symbol`: PTC 2심볼 복호, Hmat(conj(H(1,:)), H(2,:); …), 정규화·파워 스케일.
- `CPR_1Symbol2`, `CPEEst_1Symbol2`, `CPEComp_1Symbol2`: 두 번째 스트림 conj 반영 CPE.
- `CPR_2Symbol`, `CPEEst_2Symbol`, `CPEComp_2Symbol`: 2심볼 단위 CPE.
- `SFOEst_1Symbol_PTC`, `SFOComp_1Symbol_PTC`: PTC용 SFO 추정/보상.

→ **반영 시**: 현재 프로젝트의 “심볼 단위 + acc_cpe” 구조를 PTC-OFDM에 넣을 경우, PTC의 2심볼 루프·DEC_2Symbol·PTC 전용 CPE/SFO와 **공존**하도록 설계해야 함.

---

## 3. InitFiles/ReInit_OFDM.m

### 3.1 reinit_ce
| 항목 | 현재 (OFDM_coherent_Feb2026) | PTC-OFDM |
|------|-----------------------------|----------|
| ce.NRXStream | 없음 (NTXStream만 사용) | `ce.NRXStream = params.NRXStream` |

- 현재 프로젝트는 ce에 NRXStream을 넣지 않음. PTC-OFDM은 1×2 구성을 위해 NRXStream 사용.

### 3.2 reinit_ltf (LTF_type)
| 항목 | 현재 (OFDM_coherent_Feb2026) | PTC-OFDM |
|------|-----------------------------|----------|
| LTF_type == 2 | 없음 | `[LTF -conj(LTF); LTF conj(LTF)]` (PTC 타입) |

- 현재는 `LTF_type == 1`만 있음 ([A A; A -A]). PTC-OFDM은 type 2로 PTC LTF 행렬 지원.

### 3.3 기타
- 현재: `params.OFDE.en` 설정, `get_OFDE` 호출 등 채널/OFDE 관련 일부 차이.
- PTC-OFDM: `params.ptbc = reinit_ptbc(...)` 호출 있음.

---

## 4. InitFiles/Init_OFDM.m

- 현재: `params.Nbpsc_sc = params.Nbpsc * ones(params.NTXStream, params.Nsd);` 한 줄.
- PTC-OFDM: PTBC 주석 처리된 분기 후 동일한 Nbpsc_sc 설정.
- `params.LTF_type`: 현재 1만 사용, PTC-OFDM은 2도 사용 가능 (reinit_ltf와 일치).

---

## 5. 요약: “현재 → PTC-OFDM” 반영 시 주의점

1. **ChannelEst.m**  
   - 현재는 **2×2 등화기**와 `transpose(TX/RX)` → `TX/RX` 변경(@jason).  
   - PTC-OFDM은 **1×2 등화기**와 PTC LTF 타입이므로, “등화기 식만 맞춘다”면 **1×2 + inv(TX)*RX(1,:).'** 구조는 유지하고, 필요 시 **수식 형태만** 참고.

2. **ChannelComp.m**  
   - 현재는 **심볼 단위 등화 + CPR/SPR에 acc_cpe 사용**.  
   - PTC-OFDM은 **2심볼 단위 PTC 복호(DEC_2Symbol) + PTC 전용 CPE/SFO**.  
   - 반영 시: acc_cpe 전달·업데이트, CPR_1Symbol 시그니처 등은 “선택 반영”하고, PTC 전용 블록(DEC_2Symbol, CPR_1Symbol2, SFO_*_PTC)은 그대로 두는 것이 안전.

3. **ReInit_OFDM.m / Init_OFDM.m**  
   - ce.NRXStream, LTF_type 2, ptbc, OFDE 등은 **구성 차이**이므로, “현재처럼 NRXStream 없이 통일”할지, “PTC는 NRXStream·LTF_type 2 유지”할지 정책에 따라 선택.

4. **ISFA / CEAnalysis**  
   - 두 프로젝트 모두 ISFA 사용. CEAnalysis에서 H_ISFA 인덱싱만 약간 다름 (현재: `mod(iaxes-1,2)+1`, PTC: `i, j`).  
   - 선택 반영 시 인덱싱만 맞추면 됨.

---

## 6. 파일별 체크리스트 (선택 반영 시)

| 파일 | 반영 고려 항목 | 비고 |
|------|----------------|------|
| Receiver/ChannelEst.m | H 차원(NTX vs NRX), ChannelEst_AA 식 (2×2 vs 1×2) | PTC는 1×2 유지 권장 |
| Receiver/ChannelComp.m | NDataSymbol 분기, acc_cpe 전달, CPR 시그니처 | PTC 전용 DEC_2Symbol 등 유지 |
| InitFiles/ReInit_OFDM.m | ce.NRXStream, reinit_ltf LTF_type 2, OFDE, ptbc | 구성 선택 |
| InitFiles/Init_OFDM.m | Nbpsc_sc, LTF_type | 구성 선택 |
| Analysis/CEAnalysis.m | H_ISFA 인덱싱 | 호환만 맞추면 됨 |

— 문서 끝. PTC-OFDM 쪽 코드는 수정하지 않았으며, 위 내용은 수동 반영 시 참고용입니다.
