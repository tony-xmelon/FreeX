# Project Build History Metrics

Generated: 2026-08-08 12:52 +03:00
Repository: https://github.com/tony-xmelon/FreeX.git
Baseline ref: HEAD at `e0878c025` (`e0878c02514c17f3bb508023df5aed899de3d338`)
History window: 2026-05-12 through 2026-08-08

## Scope And Caveats

- This doc is produced by the committable, repeatable extractor `tools/Build-ProjectHistoryMetrics.ps1`, not a one-off local script. Re-run it to refresh.
- Daily build rows are Git numstat churn for all commits reachable from HEAD (not just first-parent) whose commit date falls in the window, bucketed by that commit date in this machine's local timezone. A no-rename numstat pass is used, so renamed files are represented by their added and removed lines.
- Files Changed is the count of *distinct* file paths touched that day (deduplicated across the day's commits); LoC/Source/Test/Docs +/- are the raw additive churn (not deduplicated), i.e. repeated edits to the same file all count.
- Source C# / Test C# is split by path: a `.cs` file is classified as a test file if any path segment is `test`/`tests` (case-insensitive) or the filename ends in `Test(s).cs`; everything else `.cs` is source. Docs +/- covers every tracked `.md` file, not only `docs/`.
- Current repository footprint LOC counts are exact for the current checkout (`git ls-files` + line counts). Historical cumulative LOC per day is not computed (would require checking out every daily snapshot).
- **Token columns currently reflect only the machine(s) that have contributed a project-history-tokens-<MachineId>.json file into `.metrics-data` so far: ALITOP, I5-32GB.** This run's own machine id is `ALITOP`. Other machines' logs are pending: copy their project-history-tokens-*.json (produced by running this same script there) into that directory and re-run to aggregate. The git-derived metrics above and below are complete/authoritative regardless of which machines have reported tokens.
- Anthropic (Claude Code) token rows sum `message.usage` fields from every `*.jsonl` transcript (including subagent transcripts) under `~/.claude/projects/*FreeX*`, deduplicated by `requestId` where present. Only numeric usage + timestamp + model were read - no transcript content was inspected or stored.
- OpenAI (Codex) token rows sum `payload.info.last_token_usage` from `token_count` events in `~/.codex/sessions/**/*.jsonl` and `~/.codex/archived_sessions/*.jsonl`, filtered to sessions whose recorded `cwd` contains "FreeX". Codex's sqlite logs (`logs_2.sqlite` etc.) were **not** parsed - no stable, documented per-day usage schema was available there without heavy reverse-engineering, so per the "do not guess" rule they are left out rather than estimated.
- Codex extraction note (ALITOP: Codex jsonl sessions were extracted via payload.info.last_token_usage on event_msg/token_count lines, filtered to sessions whose recorded cwd contains 'FreeX'. Codex's sqlite logs (logs_2.sqlite etc.) were NOT parsed (no stable documented per-day usage schema without heavy reverse-engineering) - if the jsonl sessions directories are ever pruned/rotated, coverage for older dates could be incomplete.)
- Codex extraction note (I5-32GB: Codex jsonl sessions were extracted via payload.info.last_token_usage on event_msg/token_count lines, filtered to sessions whose recorded cwd contains 'FreeX'. Codex's sqlite logs (logs_2.sqlite etc.) were NOT parsed (no stable documented per-day usage schema without heavy reverse-engineering) - if the jsonl sessions directories are ever pruned/rotated, coverage for older dates could be incomplete.)
- Raw Tokens for Anthropic = Input + Cached Input + Cache Write + Cache Read + Output + Reasoning (Anthropic cache tokens are billed as distinct additive token types). Raw Tokens for OpenAI = Input + Output + Reasoning (OpenAI's `input_tokens` already includes `cached_input_tokens` as a discounted subset, so it is not added again; Cached Input is shown for visibility only).
- Billable Eq Tokens applies simple cache weighting to make the local logs easier to compare with provider dashboards: OpenAI cached input at 0.5x, Anthropic cache write at 1.25x, Anthropic cache read at 0.1x, and all other input/output/reasoning tokens at 1x. This is an approximation, not an invoice.

## Current Repository Footprint

- Registered worktrees: 9
- Local branches: 14
- Remote branches: 543
- Tracked files: 13,894
- Current C# source LOC: 1,234,385
- Current C# test LOC: 1,185,402
- Current XAML LOC: 6,862
- Current docs LOC: 137,517
- Observed Codex JSONL sessions/logs (this machine, all projects, unfiltered): 382
- Observed Claude FreeX JSONL sessions/logs (this machine): 573
- Provider log bytes attributed (all machines reporting so far): 173,841,999,603
- Observed raw provider tokens (all machines reporting so far): 3,987,652,455,497
- Provider-style billable-equivalent tokens (all machines reporting so far): 2,039,708,521,756

## Daily Build Churn

| Date | Commits | Files Changed | LoC +/- | Source C# +/- | Test C# +/- | Docs +/- | Bytes +/- | OpenAI Tokens | Anthropic Tokens | Git Authors |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2026-05-12 | 21 | 46 | +6,520 / -121 | +4,349 / -113 | +1,672 / -1 | +217 / -0 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-13 | 27 | 1695 | +56,420 / -40,844 | +8,579 / -2,151 | +2,847 / -418 | +5,146 / -5 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-14 | 24 | 57 | +10,239 / -736 | +4,244 / -451 | +1,330 / -0 | +3,671 / -32 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-15 | 26 | 173 | +30,205 / -848 | +15,827 / -788 | +7,135 / -10 | +2,952 / -16 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-16 | 39 | 285 | +42,607 / -4,580 | +17,290 / -2,854 | +20,324 / -1,390 | +30 / -28 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-17 | 33 | 35969 | +649,481 / -637,975 | +7,903 / -962 | +3,859 / -246 | +2,479 / -132 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-18 | 20 | 120 | +28,420 / -4,156 | +15,762 / -1,342 | +8,712 / -191 | +3,291 / -2,412 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-19 | 811 | 449 | +61,812 / -9,990 | +31,075 / -7,680 | +24,138 / -581 | +4,875 / -1,183 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-20 | 690 | 286 | +44,418 / -16,508 | +26,656 / -14,721 | +11,786 / -233 | +2,123 / -827 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-21 | 762 | 3997 | +53,310 / -25,641 | +31,633 / -21,474 | +8,048 / -1,113 | +3,191 / -1,070 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-22 | 366 | 908 | +52,373 / -27,105 | +27,707 / -20,953 | +4,433 / -161 | +691 / -118 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-23 | 1201 | 1054 | +58,138 / -43,831 | +29,006 / -20,566 | +13,437 / -379 | +1,080 / -308 | +0 / -0 | 0 | 0 | 2 |
| 2026-05-24 | 1374 | 2067 | +58,047 / -24,632 | +30,886 / -15,126 | +14,265 / -295 | +1,799 / -386 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-25 | 718 | 866 | +36,866 / -10,715 | +19,660 / -4,447 | +14,209 / -301 | +1,745 / -263 | +0 / -0 | 0 | 0 | 2 |
| 2026-05-26 | 1470 | 616 | +62,189 / -25,784 | +33,720 / -22,040 | +26,024 / -1,922 | +1,636 / -1,337 | +0 / -0 | 0 | 0 | 2 |
| 2026-05-27 | 1405 | 440 | +36,301 / -10,217 | +17,580 / -8,443 | +16,681 / -452 | +987 / -688 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-28 | 937 | 468 | +27,736 / -6,691 | +11,212 / -5,041 | +14,032 / -770 | +1,821 / -719 | +0 / -0 | 0 | 0 | 2 |
| 2026-05-29 | 1113 | 3606 | +385,507 / -368,477 | +183,073 / -178,910 | +185,647 / -174,292 | +3,347 / -2,889 | +0 / -0 | 0 | 0 | 2 |
| 2026-05-30 | 506 | 871 | +55,970 / -18,599 | +14,507 / -4,745 | +14,808 / -2,718 | +3,930 / -871 | +0 / -0 | 0 | 0 | 1 |
| 2026-05-31 | 246 | 258 | +30,256 / -2,952 | +6,950 / -1,224 | +7,245 / -698 | +287 / -219 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-01 | 1007 | 562 | +685,723 / -6,681 | +25,531 / -5,076 | +21,838 / -519 | +1,411 / -657 | +67,440 / -0 | 59,914 | 0 | 1 |
| 2026-06-02 | 1000 | 410 | +30,881 / -4,046 | +13,213 / -2,955 | +15,094 / -451 | +619 / -310 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-03 | 954 | 1135 | +188,898 / -152,007 | +40,640 / -22,684 | +142,398 / -128,355 | +2,990 / -714 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-04 | 466 | 1056 | +67,307 / -42,327 | +16,232 / -1,288 | +11,751 / -4,279 | +31,479 / -33,364 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-05 | 938 | 383 | +49,940 / -12,038 | +33,127 / -5,487 | +15,019 / -5,290 | +1,362 / -939 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-06 | 1234 | 564 | +38,101 / -6,045 | +15,244 / -1,785 | +20,316 / -3,223 | +1,222 / -780 | +0 / -0 | 0 | 0 | 2 |
| 2026-06-07 | 997 | 452 | +90,611 / -10,079 | +53,176 / -6,801 | +31,762 / -2,767 | +3,646 / -401 | +0 / -0 | 0 | 0 | 2 |
| 2026-06-08 | 1414 | 903 | +92,034 / -9,527 | +32,955 / -6,770 | +27,573 / -990 | +3,011 / -440 | +2,813,661 / -0 | 6,039,307 | 0 | 2 |
| 2026-06-09 | 106 | 173 | +9,452 / -723 | +4,811 / -284 | +2,944 / -87 | +184 / -70 | +0 / -0 | 0 | 0 | 2 |
| 2026-06-10 | 310 | 949 | +64,626 / -2,273 | +36,430 / -1,250 | +6,759 / -262 | +1,402 / -466 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-11 | 149 | 438 | +21,156 / -1,949 | +8,114 / -930 | +4,064 / -324 | +1,133 / -60 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-12 | 132 | 700 | +45,512 / -20,325 | +8,665 / -2,034 | +30,433 / -18,133 | +432 / -67 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-13 | 111 | 202 | +10,749 / -1,287 | +5,052 / -812 | +3,749 / -165 | +432 / -141 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-14 | 18 | 105 | +7,941 / -318 | +2,317 / -169 | +1,063 / -113 | +101 / -9 | +0 / -0 | 0 | 0 | 1 |
| 2026-06-15 | 70 | 157 | +13,869 / -1,562 | +7,529 / -1,437 | +4,047 / -8 | +1,717 / -79 | +16,189,145 / -0 | 217,058 | 54,731,836 | 2 |
| 2026-06-16 | 107 | 334 | +18,140 / -12,667 | +10,949 / -6,481 | +1,878 / -2,265 | +2,414 / -19 | +17,902,208 / -0 | 369,236 | 19,041,753 | 2 |
| 2026-06-17 | 556 | 709 | +107,409 / -5,766 | +66,962 / -3,569 | +34,555 / -1,483 | +3,169 / -466 | +8,269,141 / -0 | 55,874,027 | 0 | 2 |
| 2026-06-18 | 205 | 1163 | +32,866 / -8,917 | +20,486 / -4,674 | +6,557 / -1,220 | +1,718 / -189 | +88,205,577 / -0 | 51,822,119 | 271,702,003 | 3 |
| 2026-06-19 | 418 | 1114 | +118,113 / -28,365 | +61,232 / -12,779 | +22,205 / -2,466 | +2,755 / -288 | +219,961,637 / -0 | 236,385,059 | 1,500,603,716 | 4 |
| 2026-06-20 | 114 | 227 | +16,009 / -1,515 | +7,134 / -998 | +8,324 / -381 | +182 / -101 | +845,728,399 / -0 | 932,457,783 | 0 | 2 |
| 2026-06-21 | 151 | 446 | +24,518 / -23,151 | +15,157 / -10,093 | +8,180 / -1,372 | +1,009 / -557 | +1,558,832,973 / -0 | 2,367,286,629 | 0 | 2 |
| 2026-06-22 | 150 | 328 | +24,526 / -6,772 | +14,516 / -4,388 | +7,009 / -2,020 | +965 / -167 | +1,385,410,206 / -0 | 1,881,342,028 | 0 | 2 |
| 2026-06-23 | 258 | 626 | +29,831 / -8,475 | +17,992 / -5,945 | +7,979 / -2,210 | +2,153 / -180 | +1,259,142,261 / -0 | 1,164,660,342 | 233,816,141 | 3 |
| 2026-06-24 | 167 | 582 | +49,927 / -2,328 | +29,247 / -1,818 | +17,872 / -230 | +440 / -68 | +172,737,114 / -0 | 0 | 1,172,866,673 | 3 |
| 2026-06-25 | 209 | 837 | +789,630 / -715,512 | +48,513 / -4,174 | +21,221 / -297 | +1,919 / -96 | +430,427,820 / -0 | 0 | 1,998,791,712 | 2 |
| 2026-06-26 | 388 | 582 | +130,777 / -5,445 | +69,513 / -5,128 | +60,112 / -272 | +903 / -13 | +445,111,027 / -0 | 0 | 3,031,581,553 | 2 |
| 2026-06-27 | 45 | 151 | +11,669 / -2,289 | +5,798 / -1,678 | +5,389 / -581 | +376 / -2 | +1,523,451,319 / -0 | 240,773,796 | 140,513,107 | 2 |
| 2026-06-28 | 277 | 931 | +53,729 / -36,191 | +33,441 / -26,979 | +19,839 / -8,955 | +9 / -9 | +348,237,946 / -0 | 1,087,310,744 | 0 | 1 |
| 2026-06-29 | 214 | 569 | +37,591 / -10,686 | +22,494 / -10,029 | +14,378 / -636 | +2 / -2 | +377,021,044 / -0 | 1,063,985,386 | 0 | 1 |
| 2026-06-30 | 300 | 747 | +44,167 / -21,445 | +28,640 / -20,124 | +14,286 / -1,046 | +34 / -33 | +639,030,586 / -0 | 1,299,562,494 | 0 | 1 |
| 2026-07-01 | 180 | 507 | +77,681 / -19,690 | +14,211 / -3,418 | +10,916 / -272 | +4,587 / -2,870 | +1,501,891,347 / -0 | 1,110,955,972 | 0 | 2 |
| 2026-07-02 | 250 | 279 | +44,415 / -4,972 | +25,352 / -2,245 | +13,790 / -396 | +800 / -482 | +1,517,084,859 / -0 | 4,668,395,839 | 343,401,673 | 2 |
| 2026-07-03 | 521 | 474 | +65,078 / -8,289 | +29,886 / -3,200 | +20,256 / -401 | +1,564 / -913 | +1,496,267,240 / -0 | 8,166,552,226 | 90,088,061 | 1 |
| 2026-07-04 | 390 | 538 | +51,704 / -5,524 | +20,790 / -2,544 | +27,109 / -313 | +1,716 / -1,213 | +1,470,688,709 / -0 | 12,241,939,818 | 209,752,996 | 1 |
| 2026-07-05 | 168 | 449 | +41,883 / -3,884 | +17,068 / -1,729 | +18,155 / -390 | +777 / -278 | +1,244,691,408 / -0 | 1,562,699,038 | 354,424,446 | 1 |
| 2026-07-06 | 95 | 353 | +26,690 / -2,044 | +16,398 / -1,620 | +9,043 / -142 | +750 / -63 | +1,251,657,576 / -0 | 2,346,225,671 | 115,379,441 | 1 |
| 2026-07-07 | 88 | 354 | +34,032 / -2,281 | +14,457 / -1,901 | +18,805 / -222 | +428 / -98 | +1,493,599,997 / -0 | 17,362,096,552 | 207,687,836 | 1 |
| 2026-07-08 | 1 | 7 | +268 / -8 | +71 / -6 | +22 / -0 | +28 / -0 | +174,891,615 / -0 | 33,935,675 | 18,562,148 | 1 |
| 2026-07-09 | 9 | 384 | +25,047 / -1,179 | +8,096 / -1,081 | +16,951 / -98 | +0 / -0 | +154,060,259 / -0 | 0 | 323,802,697 | 1 |
| 2026-07-10 | 8 | 27 | +2,567 / -1,619 | +1,167 / -1,617 | +1,400 / -2 | +0 / -0 | +154,073,108 / -0 | 0 | 162,635,017 | 1 |
| 2026-07-11 | 9 | 342 | +28,082 / -1,207 | +6,911 / -1,071 | +21,168 / -134 | +3 / -2 | +154,570,070 / -0 | 0 | 242,606,778 | 1 |
| 2026-07-12 | 12 | 243 | +15,962 / -1,005 | +3,676 / -863 | +12,285 / -142 | +0 / -0 | +162,521,896 / -0 | 0 | 191,679,547 | 1 |
| 2026-07-13 | 188 | 610 | +67,031 / -3,507 | +25,658 / -2,355 | +37,055 / -459 | +1,616 / -90 | +1,295,139,844 / -0 | 1,143,617,258 | 216,933,331 | 1 |
| 2026-07-14 | 235 | 359 | +35,039 / -3,253 | +13,890 / -1,041 | +12,713 / -321 | +3,375 / -361 | +3,684,935,696 / -0 | 1,225,880,889 | 0 | 2 |
| 2026-07-15 | 205 | 503 | +20,341 / -14,048 | +11,677 / -8,853 | +6,003 / -2,734 | +651 / -13 | +3,358,746,009 / -0 | 2,843,226,916 | 0 | 2 |
| 2026-07-16 | 158 | 450 | +27,920 / -7,478 | +10,911 / -2,853 | +11,256 / -558 | +1,812 / -13 | +3,442,436,417 / -0 | 2,023,391,638 | 81,062,676 | 2 |
| 2026-07-17 | 196 | 331 | +27,020 / -2,642 | +15,367 / -2,078 | +8,973 / -453 | +1,856 / -19 | +4,469,116,234 / -0 | 63,289,720,927 | 45,186,610 | 2 |
| 2026-07-18 | 98 | 105 | +4,217 / -219 | +999 / -190 | +743 / -19 | +2,475 / -10 | +2,561,375,818 / -0 | 1,007,536,412 | 0 | 1 |
| 2026-07-19 | 156 | 227 | +19,191 / -1,676 | +7,533 / -1,192 | +7,832 / -193 | +1,344 / -9 | +5,392,114,405 / -0 | 100,942,869,322 | 48,654,724 | 2 |
| 2026-07-20 | 352 | 1021 | +169,028 / -38,924 | +45,290 / -6,462 | +21,851 / -561 | +6,446 / -2,881 | +6,284,074,571 / -0 | 149,942,983,988 | 135,012,834 | 2 |
| 2026-07-21 | 13 | 243 | +16,264 / -1,687 | +5,169 / -1,190 | +11,095 / -497 | +0 / -0 | +152,847,786 / -0 | 0 | 200,924,428 | 1 |
| 2026-07-22 | 15 | 450 | +38,309 / -1,523 | +9,738 / -1,314 | +28,552 / -208 | +1 / -1 | +167,747,995 / -0 | 0 | 439,393,079 | 1 |
| 2026-07-23 | 400 | 744 | +49,562 / -4,252 | +15,644 / -2,888 | +26,640 / -487 | +3,272 / -77 | +7,614,759,534 / -0 | 233,783,932,953 | 311,898,845 | 2 |
| 2026-07-24 | 258 | 620 | +50,753 / -4,053 | +23,409 / -2,532 | +18,986 / -342 | +2,197 / -268 | +7,212,703,654 / -0 | 209,289,198,125 | 183,310,251 | 2 |
| 2026-07-25 | 156 | 451 | +39,870 / -2,658 | +14,272 / -1,334 | +15,695 / -168 | +955 / -141 | +5,529,436,703 / -0 | 112,177,911,453 | 196,786,379 | 2 |
| 2026-07-26 | 167 | 381 | +26,722 / -2,319 | +12,269 / -1,343 | +10,364 / -258 | +1,159 / -115 | +4,780,634,939 / -0 | 71,942,218,968 | 20,566,622 | 2 |
| 2026-07-27 | 310 | 543 | +44,504 / -7,100 | +17,222 / -2,285 | +11,392 / -289 | +4,588 / -497 | +9,522,780,199 / -0 | 337,715,936,790 | 0 | 2 |
| 2026-07-28 | 263 | 407 | +29,768 / -5,476 | +10,658 / -1,814 | +7,776 / -402 | +2,974 / -215 | +7,427,226,983 / -0 | 214,549,653,877 | 0 | 2 |
| 2026-07-29 | 307 | 389 | +24,216 / -2,950 | +9,251 / -1,424 | +7,197 / -340 | +3,469 / -297 | +8,033,274,421 / -0 | 241,037,536,105 | 11,563,058 | 3 |
| 2026-07-30 | 254 | 844 | +69,126 / -4,820 | +23,004 / -2,511 | +32,898 / -292 | +3,768 / -258 | +7,499,470,212 / -0 | 202,342,188,687 | 525,195,164 | 3 |
| 2026-07-31 | 312 | 644 | +54,582 / -3,696 | +16,885 / -2,600 | +31,149 / -395 | +3,754 / -154 | +7,444,468,149 / -0 | 205,236,176,495 | 508,254,318 | 2 |
| 2026-08-01 | 349 | 699 | +60,298 / -4,212 | +21,920 / -3,059 | +26,642 / -226 | +6,532 / -243 | +8,433,378,671 / -0 | 258,059,999,975 | 116,747,476 | 2 |
| 2026-08-02 | 521 | 825 | +71,358 / -8,860 | +26,531 / -4,086 | +31,391 / -688 | +6,505 / -575 | +10,072,668,877 / -0 | 328,820,627,439 | 239,468,802 | 2 |
| 2026-08-03 | 137 | 536 | +35,002 / -6,520 | +10,477 / -2,349 | +15,914 / -316 | +4,613 / -354 | +7,751,664,375 / -0 | 223,971,202,038 | 102,561,052 | 2 |
| 2026-08-04 | 467 | 671 | +43,365 / -4,513 | +20,069 / -3,253 | +14,974 / -557 | +7,378 / -240 | +10,116,146,138 / -0 | 326,892,350,173 | 0 | 2 |
| 2026-08-05 | 224 | 307 | +24,065 / -2,223 | +11,892 / -1,839 | +8,633 / -129 | +3,154 / -69 | +11,130,821,965 / -0 | 358,365,097,981 | 0 | 2 |
| 2026-08-06 | 184 | 467 | +29,465 / -2,420 | +10,021 / -1,629 | +15,146 / -487 | +3,218 / -145 | +9,990,312,638 / -0 | 268,022,581,345 | 401,538,372 | 2 |
| 2026-08-07 | 3 | 169 | +13,616 / -408 | +2,577 / -372 | +11,002 / -36 | +0 / -0 | +177,084,545 / -0 | 0 | 478,156,785 | 1 |
| 2026-08-08 | 18 | 160 | +23,969 / -9,309 | +2,756 / -183 | +6,644 / -388 | +12,121 / -8,709 | +182,095,237 / -0 | 0 | 198,785,090 | 3 |
| TOTAL | 31,931 | 88,879 | +6,220,527 / -2,643,561 | +1,845,901 / -596,974 | +1,597,642 / -390,886 | +214,373 / -75,863 | +173,841,999,603 / -0 | 3,972,506,786,467 | 15,145,669,030 | 6 |

## Git Churn By App

- Buckets are assigned by repo path prefix: `FreeX` = `src/**` + `tests/**`; `FreeW` = `freew/**`; `FreeP` = `freep/**`; `Shared` = `shared/**`; `Docs/Tooling/Other` = everything else (`docs/**`, `tools/**`, top-level files, screenshots/fixture/corpus dirs, etc.).
- `tests/**` is bucketed under `FreeX` even where it exercises `Shared`/`FreeW`/`FreeP` code, because the shared test projects that live under `tests/` predate the FreeW/FreeP split; see the "By Platform Layer" section below for a platform-aware (not app-aware) view of the same `tests/**` paths.
- "Files Changed" and "LoC +/-" are an EXACT partition of the same `git log --numstat` data behind Daily Build Churn above: every changed path is assigned to exactly one bucket, so these two columns sum exactly to the Daily Build Churn TOTAL row (the generator asserts this at build time and warns if it ever drifts).
- "Commits" counts a commit once per bucket if it touched at least one path in that bucket (a commit touching multiple buckets is counted in each), so it is NOT expected to sum to the Daily Build Churn TOTAL commit count: git suppresses `--numstat` output for merge commits unless `-m`/`-c` is passed, so a merge commit with no line-level diff is tallied in the overall commit total but contributes to zero buckets here.
- "Files Changed" is the sum of per-day distinct-path counts (matches the Daily Build Churn convention, not a window-wide dedup).

### Git Churn By App - Summary

| App | Commits | Files Changed | LoC +/- |
| --- | ---: | ---: | ---: |
| FreeX | 10,974 | 36,696 | +3,973,748 / -1,708,135 |
| FreeW | 2,042 | 4,781 | +480,982 / -51,011 |
| FreeP | 2,194 | 3,536 | +440,041 / -43,280 |
| Shared | 456 | 759 | +50,150 / -5,815 |
| Docs/Tooling/Other | 7,910 | 43,107 | +1,275,606 / -835,320 |
| TOTAL | 23,576 | 88,879 | +6,220,527 / -2,643,561 |

### Git Churn By App - Monthly

| Month | App | Commits | Files Changed | LoC +/- |
| --- | --- | ---: | ---: | ---: |
| 2026-05 | Docs/Tooling/Other | 2,480 | 36,849 | +700,892 / -659,722 |
| 2026-05 | FreeX | 5,392 | 17,382 | +1,085,923 / -620,680 |
| 2026-06 | Docs/Tooling/Other | 1,899 | 2,368 | +204,610 / -75,886 |
| 2026-06 | FreeP | 288 | 527 | +102,235 / -14,312 |
| 2026-06 | FreeW | 626 | 2,070 | +233,419 / -20,957 |
| 2026-06 | FreeX | 4,633 | 12,103 | +2,332,663 / -1,046,453 |
| 2026-06 | Shared | 242 | 467 | +32,775 / -3,103 |
| 2026-07 | Docs/Tooling/Other | 2,453 | 2,899 | +305,824 / -80,833 |
| 2026-07 | FreeP | 1,488 | 2,305 | +267,638 / -23,781 |
| 2026-07 | FreeW | 964 | 1,869 | +182,194 / -22,960 |
| 2026-07 | FreeX | 750 | 5,996 | +459,715 / -34,800 |
| 2026-07 | Shared | 141 | 210 | +11,501 / -1,609 |
| 2026-08 | Docs/Tooling/Other | 1,078 | 991 | +64,280 / -18,879 |
| 2026-08 | FreeP | 418 | 704 | +70,168 / -5,187 |
| 2026-08 | FreeW | 452 | 842 | +65,369 / -7,094 |
| 2026-08 | FreeX | 199 | 1,215 | +95,447 / -6,202 |
| 2026-08 | Shared | 73 | 82 | +5,874 / -1,103 |

## Git Churn By Platform Layer

- The codebase is organized by UI framework, not OS, so "platform" here means UI framework layer: `Windows (WPF)` = any path under `src/**`, `tests/**`, `freew/**`, `freep/**`, or `shared/**` matching `*.App.Host*`, `*.App.UI*`, `*.Wpf*`, or `*Free.Shared.*.Windows*` (e.g. `src/FreeX.App.Host`, `shared/Free.Shared.Ribbon.Wpf`, `shared/Free.Shared.AppServices.Windows`).
- `Avalonia (Linux/macOS)` = same code area matching `*.App.Avalonia*`, `*.App.Rendering.Avalonia*`, or `*Free.Shared.*.Avalonia*` (e.g. `freep/FreeP.App.Rendering.Avalonia`, `shared/Free.Shared.Shell.Avalonia`).
- `Platform-neutral (core/shared/IO/model)` = everything else under those same four top-level dirs (Core.*, App.Presentation, App.Services, Ribbon.Definitions, IO, Model, Commands, Drawing, Opc, Pdf/Pdf.Skia, etc.).
- `Non-code` = everything outside `src/**`, `tests/**`, `freew/**`, `freep/**`, `shared/**` (`docs/**`, `tools/**`, top-level files, etc.).
- Caveat: this is literal-glob matching per the above patterns, not a semantic "runs on Windows" judgment - e.g. `freep/FreeP.App.Ole.Windows` and `freep/FreeP.App.Recording.Windows` have "Windows" in their project name but do not match any of the `Windows (WPF)` globs above (no `.App.Host`, `.App.UI`, `.Wpf`, or `Free.Shared.*.Windows` substring), so they land in `Platform-neutral`.
- "Files Changed" and "LoC +/-" are an EXACT partition of the same `git log --numstat` data behind Daily Build Churn above: every changed path is assigned to exactly one bucket, so these two columns sum exactly to the Daily Build Churn TOTAL row (the generator asserts this at build time and warns if it ever drifts).
- "Commits" counts a commit once per bucket if it touched at least one path in that bucket (a commit touching multiple buckets is counted in each), so it is NOT expected to sum to the Daily Build Churn TOTAL commit count: git suppresses `--numstat` output for merge commits unless `-m`/`-c` is passed, so a merge commit with no line-level diff is tallied in the overall commit total but contributes to zero buckets here.
- "Files Changed" is the sum of per-day distinct-path counts (matches the Daily Build Churn convention, not a window-wide dedup).

### Git Churn By Platform Layer - Summary

| Platform Layer | Commits | Files Changed | LoC +/- |
| --- | ---: | ---: | ---: |
| Windows (WPF) | 7,800 | 22,281 | +1,772,719 / -1,218,880 |
| Avalonia (Linux/macOS) | 3,282 | 3,405 | +414,468 / -64,944 |
| Platform-neutral (core/shared/IO/model) | 9,328 | 20,086 | +2,757,734 / -524,417 |
| Non-code | 7,910 | 43,107 | +1,275,606 / -835,320 |
| TOTAL | 28,320 | 88,879 | +6,220,527 / -2,643,561 |

### Git Churn By Platform Layer - Monthly

| Month | Platform Layer | Commits | Files Changed | LoC +/- |
| --- | --- | ---: | ---: | ---: |
| 2026-05 | Non-code | 2,480 | 36,849 | +700,892 / -659,722 |
| 2026-05 | Platform-neutral (core/shared/IO/model) | 2,573 | 5,073 | +557,155 / -321,336 |
| 2026-05 | Windows (WPF) | 3,073 | 12,309 | +528,768 / -299,344 |
| 2026-06 | Avalonia (Linux/macOS) | 885 | 1,092 | +169,154 / -32,458 |
| 2026-06 | Non-code | 1,899 | 2,368 | +204,610 / -75,886 |
| 2026-06 | Platform-neutral (core/shared/IO/model) | 3,617 | 6,757 | +1,473,366 / -157,227 |
| 2026-06 | Windows (WPF) | 2,494 | 7,318 | +1,058,572 / -895,140 |
| 2026-07 | Avalonia (Linux/macOS) | 1,744 | 1,692 | +189,756 / -25,585 |
| 2026-07 | Non-code | 2,453 | 2,899 | +305,824 / -80,833 |
| 2026-07 | Platform-neutral (core/shared/IO/model) | 2,367 | 6,665 | +590,717 / -37,656 |
| 2026-07 | Windows (WPF) | 1,696 | 2,023 | +140,575 / -19,909 |
| 2026-08 | Avalonia (Linux/macOS) | 653 | 621 | +55,558 / -6,901 |
| 2026-08 | Non-code | 1,078 | 991 | +64,280 / -18,879 |
| 2026-08 | Platform-neutral (core/shared/IO/model) | 771 | 1,591 | +136,496 / -8,198 |
| 2026-08 | Windows (WPF) | 537 | 631 | +44,804 / -4,487 |

## Daily Provider Token Usage

| Date | Provider | Files | Sessions | Events | Bytes +/- | Input | Cached Input | Cache Write | Cache Read | Output | Reasoning | Raw Tokens | Billable Eq Tokens |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2026-07-22 | anthropic | 26 | 26 | 1,874 | 167,747,995 | 31,569 | 0 | 10,405,430 | 427,630,538 | 1,325,542 | 0 | 439,393,079 | 57,126,952 |
| 2026-07-23 | anthropic | 16 | 16 | 1,213 | 166,790,601 | 13,949 | 0 | 7,252,438 | 303,444,513 | 1,187,945 | 0 | 311,898,845 | 40,611,893 |
| 2026-07-21 | anthropic | 2 | 2 | 406 | 152,847,786 | 812 | 0 | 3,718,316 | 196,772,206 | 433,094 | 0 | 200,924,428 | 24,759,022 |
| 2026-07-20 | anthropic | 1 | 1 | 167 | 152,365,833 | 334 | 0 | 3,893,008 | 130,886,173 | 233,319 | 0 | 135,012,834 | 18,188,530 |
| 2026-07-20 | openai | 70 | 70 | 1,031,423 | 6,131,708,738 | 149,610,650,788 | 145,964,298,496 | 0 | 0 | 270,892,484 | 61,440,716 | 149,942,983,988 | 76,960,834,740 |
| 2026-07-25 | anthropic | 9 | 9 | 807 | 157,462,292 | 1,604 | 0 | 4,970,479 | 191,300,132 | 514,164 | 0 | 196,786,379 | 25,858,880 |
| 2026-07-25 | openai | 47 | 47 | 768,244 | 5,371,974,411 | 111,942,365,380 | 109,424,527,232 | 0 | 0 | 190,140,380 | 45,405,693 | 112,177,911,453 | 57,465,647,837 |
| 2026-07-24 | openai | 72 | 72 | 1,444,932 | 7,054,858,757 | 208,810,225,825 | 203,897,403,136 | 0 | 0 | 378,236,010 | 100,736,290 | 209,289,198,125 | 107,340,496,557 |
| 2026-07-23 | openai | 76 | 76 | 1,613,389 | 7,447,968,933 | 233,254,737,233 | 227,700,989,824 | 0 | 0 | 422,960,607 | 106,235,113 | 233,783,932,953 | 119,933,438,041 |
| 2026-07-24 | anthropic | 7 | 7 | 631 | 157,844,897 | 3,605 | 0 | 7,126,594 | 175,580,099 | 599,953 | 0 | 183,310,251 | 27,069,810 |
| 2026-07-19 | openai | 45 | 45 | 695,518 | 5,238,957,069 | 100,715,619,001 | 98,153,452,288 | 0 | 0 | 186,200,441 | 41,049,880 | 100,942,869,322 | 51,866,143,178 |
| 2026-07-15 | openai | 86 | 86 | 20,735 | 3,358,746,009 | 2,834,122,309 | 2,733,463,808 | 0 | 0 | 6,960,237 | 2,144,370 | 2,843,226,916 | 1,476,495,012 |
| 2026-07-16 | anthropic | 1 | 1 | 152 | 152,365,833 | 304 | 0 | 3,519,874 | 77,269,254 | 273,244 | 0 | 81,062,676 | 12,400,316 |
| 2026-07-14 | openai | 156 | 156 | 9,359 | 3,684,935,696 | 1,221,842,371 | 1,182,893,696 | 0 | 0 | 3,442,197 | 596,321 | 1,225,880,889 | 634,434,041 |
| 2026-07-13 | anthropic | 4 | 4 | 473 | 154,185,832 | 109,663 | 0 | 2,123,574 | 213,965,859 | 734,235 | 0 | 216,933,331 | 24,894,951 |
| 2026-07-13 | openai | 174 | 174 | 9,135 | 1,140,954,012 | 1,139,337,595 | 1,099,451,136 | 0 | 0 | 3,579,586 | 700,077 | 1,143,617,258 | 593,891,690 |
| 2026-07-18 | openai | 7 | 7 | 7,225 | 2,561,375,818 | 1,004,638,485 | 981,206,528 | 0 | 0 | 2,115,142 | 782,785 | 1,007,536,412 | 516,933,148 |
| 2026-07-19 | anthropic | 2 | 2 | 141 | 153,157,336 | 282 | 0 | 1,394,708 | 47,142,504 | 117,230 | 0 | 48,654,724 | 6,575,147 |
| 2026-07-17 | openai | 81 | 81 | 445,569 | 4,315,952,626 | 63,120,577,672 | 61,394,564,352 | 0 | 0 | 129,520,977 | 39,622,278 | 63,289,720,927 | 32,592,438,751 |
| 2026-07-16 | openai | 36 | 36 | 14,843 | 3,290,070,584 | 2,016,974,867 | 1,960,596,480 | 0 | 0 | 4,640,934 | 1,775,837 | 2,023,391,638 | 1,043,093,398 |
| 2026-07-17 | anthropic | 3 | 3 | 159 | 153,163,608 | 928 | 0 | 1,435,221 | 43,571,606 | 178,855 | 0 | 45,186,610 | 6,330,970 |
| 2026-07-26 | anthropic | 2 | 2 | 80 | 152,894,308 | 160 | 0 | 192,865 | 20,335,339 | 38,258 | 0 | 20,566,622 | 2,313,033 |
| 2026-08-03 | openai | 74 | 74 | 1,564,304 | 7,596,037,046 | 223,499,613,658 | 218,795,771,392 | 0 | 0 | 374,761,495 | 96,826,885 | 223,971,202,038 | 114,573,316,342 |
| 2026-08-04 | openai | 102 | 102 | 2,272,408 | 10,116,146,138 | 326,171,558,931 | 319,326,688,128 | 0 | 0 | 564,531,079 | 156,260,163 | 326,892,350,173 | 167,229,006,109 |
| 2026-08-03 | anthropic | 7 | 7 | 419 | 155,627,329 | 857 | 0 | 2,543,530 | 99,889,135 | 127,530 | 0 | 102,561,052 | 13,296,713 |
| 2026-08-02 | anthropic | 12 | 12 | 1,124 | 160,414,974 | 2,452 | 0 | 5,615,449 | 233,487,683 | 363,218 | 0 | 239,468,802 | 30,733,750 |
| 2026-08-02 | openai | 80 | 80 | 2,268,571 | 9,912,253,903 | 328,011,862,600 | 320,738,449,408 | 0 | 0 | 621,628,810 | 187,136,029 | 328,820,627,439 | 168,451,402,735 |
| 2026-08-07 | anthropic | 95 | 95 | 3,433 | 177,084,545 | 7,301 | 0 | 12,363,496 | 465,559,144 | 226,844 | 0 | 478,156,785 | 62,244,429 |
| 2026-08-08 | anthropic | 25 | 25 | 908 | 182,095,237 | 18,042 | 0 | 4,742,784 | 193,656,351 | 367,913 | 0 | 198,785,090 | 25,680,070 |
| 2026-08-06 | openai | 147 | 147 | 1,883,600 | 9,828,729,106 | 267,257,944,470 | 259,878,564,224 | 0 | 0 | 588,037,110 | 176,599,765 | 268,022,581,345 | 138,083,299,233 |
| 2026-08-05 | openai | 139 | 139 | 2,540,026 | 11,130,821,965 | 357,365,178,943 | 347,225,751,424 | 0 | 0 | 775,345,637 | 224,573,401 | 358,365,097,981 | 184,752,222,269 |
| 2026-08-06 | anthropic | 9 | 9 | 1,723 | 161,583,532 | 3,446 | 0 | 13,961,460 | 387,186,617 | 386,849 | 0 | 401,538,372 | 56,560,782 |
| 2026-08-01 | openai | 102 | 102 | 1,790,810 | 8,274,378,374 | 257,475,976,720 | 251,839,824,512 | 0 | 0 | 459,689,593 | 124,333,662 | 258,059,999,975 | 132,140,087,719 |
| 2026-07-29 | anthropic | 1 | 1 | 16 | 152,365,833 | 28 | 0 | 806,900 | 10,719,127 | 37,003 | 0 | 11,563,058 | 2,117,569 |
| 2026-07-29 | openai | 62 | 62 | 1,655,864 | 7,880,908,588 | 240,509,880,087 | 235,147,050,112 | 0 | 0 | 422,484,492 | 105,171,526 | 241,037,536,105 | 123,464,011,049 |
| 2026-07-28 | openai | 55 | 55 | 1,466,517 | 7,427,226,983 | 214,085,589,608 | 209,344,500,096 | 0 | 0 | 372,184,618 | 91,879,651 | 214,549,653,877 | 109,877,403,829 |
| 2026-07-26 | openai | 35 | 35 | 492,043 | 4,627,740,631 | 71,790,835,586 | 70,194,665,216 | 0 | 0 | 121,873,231 | 29,510,151 | 71,942,218,968 | 36,844,886,360 |
| 2026-07-27 | openai | 97 | 97 | 2,300,247 | 9,522,780,199 | 336,994,736,360 | 329,540,279,296 | 0 | 0 | 579,243,709 | 141,956,721 | 337,715,936,790 | 172,945,797,142 |
| 2026-07-31 | openai | 77 | 77 | 1,415,185 | 7,274,986,624 | 204,778,576,883 | 200,229,825,280 | 0 | 0 | 364,534,116 | 93,065,496 | 205,236,176,495 | 105,121,263,855 |
| 2026-08-01 | anthropic | 13 | 13 | 814 | 159,000,297 | 2,004 | 0 | 2,267,973 | 114,203,760 | 273,739 | 0 | 116,747,476 | 14,531,085 |
| 2026-07-31 | anthropic | 28 | 28 | 2,403 | 169,481,525 | 4,789 | 0 | 8,561,807 | 498,959,877 | 727,845 | 0 | 508,254,318 | 61,330,880 |
| 2026-07-30 | anthropic | 20 | 20 | 2,414 | 166,399,681 | 12,177 | 0 | 8,414,346 | 516,082,197 | 686,444 | 0 | 525,195,164 | 62,824,773 |
| 2026-07-30 | openai | 56 | 56 | 1,393,220 | 7,333,070,531 | 201,895,318,758 | 197,417,382,144 | 0 | 0 | 357,221,504 | 89,648,425 | 202,342,188,687 | 103,633,497,615 |
| 2026-07-12 | anthropic | 9 | 9 | 763 | 162,521,896 | 134,428 | 0 | 3,685,547 | 186,838,588 | 1,020,984 | 0 | 191,679,547 | 24,446,205 |
| 2026-06-23 | anthropic | 77 | 77 | 2,898 | 100,171,493 | 192,201 | 0 | 7,304,461 | 225,422,038 | 897,441 | 0 | 233,816,141 | 32,762,422 |
| 2026-06-23 | openai | 101 | 101 | 8,873 | 1,158,970,768 | 1,159,928,384 | 1,094,426,752 | 0 | 0 | 3,737,205 | 994,753 | 1,164,660,342 | 617,446,966 |
| 2026-06-22 | openai | 139 | 139 | 14,376 | 1,385,410,206 | 1,873,193,621 | 1,781,193,472 | 0 | 0 | 6,344,748 | 1,803,659 | 1,881,342,028 | 990,745,292 |
| 2026-06-20 | openai | 50 | 50 | 6,945 | 845,728,399 | 928,614,994 | 890,344,960 | 0 | 0 | 2,953,040 | 889,749 | 932,457,783 | 487,285,303 |
| 2026-06-21 | openai | 259 | 259 | 17,945 | 1,558,832,973 | 2,355,267,399 | 2,240,219,648 | 0 | 0 | 8,996,809 | 3,022,421 | 2,367,286,629 | 1,247,176,805 |
| 2026-06-27 | anthropic | 31 | 31 | 1,067 | 218,201,131 | 346,952 | 0 | 2,600,172 | 137,367,052 | 198,931 | 0 | 140,513,107 | 17,532,803 |
| 2026-06-27 | openai | 55 | 55 | 2,058 | 1,305,250,188 | 239,303,297 | 223,690,496 | 0 | 0 | 1,112,047 | 358,452 | 240,773,796 | 128,928,548 |
| 2026-06-26 | anthropic | 528 | 528 | 21,725 | 445,111,027 | 2,511,969 | 0 | 70,178,497 | 2,954,496,879 | 4,394,208 | 0 | 3,031,581,553 | 390,078,986 |
| 2026-06-24 | anthropic | 236 | 236 | 10,258 | 172,737,114 | 420,213 | 0 | 32,013,642 | 1,138,065,074 | 2,367,744 | 0 | 1,172,866,673 | 156,611,517 |
| 2026-06-25 | anthropic | 373 | 373 | 16,875 | 430,427,820 | 1,280,278 | 0 | 56,989,078 | 1,936,970,631 | 3,551,725 | 0 | 1,998,791,712 | 269,765,414 |
| 2026-06-19 | openai | 24 | 24 | 1,821 | 92,888,803 | 235,477,650 | 225,208,576 | 0 | 0 | 712,093 | 195,316 | 236,385,059 | 123,780,771 |
| 2026-06-15 | openai | 1 | 1 | 8 | 196,919 | 212,448 | 138,752 | 0 | 0 | 3,008 | 1,602 | 217,058 | 147,682 |
| 2026-06-16 | anthropic | 1 | 1 | 45 | 15,017,790 | 3,759 | 0 | 830,827 | 18,163,655 | 43,512 | 0 | 19,041,753 | 2,902,170 |
| 2026-06-15 | anthropic | 4 | 4 | 309 | 15,992,226 | 15,192 | 0 | 997,901 | 53,580,840 | 137,903 | 0 | 54,731,836 | 6,758,555 |
| 2026-06-01 | openai | 1 | 1 | 4 | 67,440 | 58,130 | 52,736 | 0 | 0 | 1,139 | 645 | 59,914 | 33,546 |
| 2026-06-08 | openai | 5 | 5 | 80 | 2,813,661 | 5,998,447 | 5,353,472 | 0 | 0 | 35,551 | 5,309 | 6,039,307 | 3,362,571 |
| 2026-06-18 | openai | 6 | 6 | 426 | 34,223,552 | 51,486,863 | 49,053,952 | 0 | 0 | 269,324 | 65,932 | 51,822,119 | 27,295,143 |
| 2026-06-19 | anthropic | 269 | 269 | 9,866 | 127,072,834 | 3,092,469 | 0 | 36,854,147 | 1,458,640,823 | 2,016,277 | 0 | 1,500,603,716 | 197,040,512 |
| 2026-06-18 | anthropic | 25 | 25 | 1,709 | 53,982,025 | 291,762 | 0 | 5,806,111 | 264,678,596 | 925,534 | 0 | 271,702,003 | 34,942,794 |
| 2026-06-16 | openai | 1 | 1 | 13 | 2,884,418 | 360,579 | 283,520 | 0 | 0 | 5,736 | 2,921 | 369,236 | 227,476 |
| 2026-06-17 | openai | 1 | 1 | 424 | 8,269,141 | 55,563,266 | 51,939,840 | 0 | 0 | 233,163 | 77,598 | 55,874,027 | 29,904,107 |
| 2026-06-28 | openai | 105 | 105 | 8,833 | 348,237,946 | 1,081,899,942 | 1,038,503,808 | 0 | 0 | 4,125,525 | 1,285,277 | 1,087,310,744 | 568,058,840 |
| 2026-07-07 | anthropic | 9 | 9 | 813 | 155,807,458 | 148,754 | 0 | 2,836,401 | 204,285,444 | 417,237 | 0 | 207,687,836 | 24,540,037 |
| 2026-07-07 | openai | 89 | 89 | 123,605 | 1,337,792,539 | 17,291,142,052 | 16,614,691,968 | 0 | 0 | 53,172,604 | 17,781,896 | 17,362,096,552 | 9,054,750,568 |
| 2026-07-06 | openai | 103 | 103 | 17,187 | 1,099,291,743 | 2,336,345,524 | 2,238,611,968 | 0 | 0 | 7,465,779 | 2,414,368 | 2,346,225,671 | 1,226,919,687 |
| 2026-07-05 | openai | 95 | 95 | 11,915 | 1,089,060,801 | 1,557,208,050 | 1,492,813,440 | 0 | 0 | 4,432,868 | 1,058,120 | 1,562,699,038 | 816,292,318 |
| 2026-07-06 | anthropic | 1 | 1 | 163 | 152,365,833 | 56,401 | 0 | 5,297,218 | 109,779,366 | 246,456 | 0 | 115,379,441 | 17,902,316 |
| 2026-07-10 | anthropic | 2 | 2 | 352 | 154,073,108 | 32,295 | 0 | 4,337,862 | 157,928,579 | 336,281 | 0 | 162,635,017 | 21,583,761 |
| 2026-07-11 | anthropic | 4 | 4 | 601 | 154,570,070 | 81,447 | 0 | 3,169,903 | 238,690,274 | 665,154 | 0 | 242,606,778 | 28,578,007 |
| 2026-07-09 | anthropic | 6 | 6 | 734 | 154,060,259 | 123,676 | 0 | 2,837,616 | 319,967,343 | 874,062 | 0 | 323,802,697 | 36,541,492 |
| 2026-07-08 | anthropic | 1 | 1 | 23 | 152,365,833 | 17,716 | 0 | 850,706 | 17,673,849 | 19,877 | 0 | 18,562,148 | 2,868,360 |
| 2026-07-08 | openai | 3 | 3 | 268 | 22,525,782 | 33,792,551 | 32,091,520 | 0 | 0 | 114,185 | 28,939 | 33,935,675 | 17,889,915 |
| 2026-07-05 | anthropic | 5 | 5 | 1,076 | 155,630,607 | 70,064 | 0 | 10,054,789 | 343,862,219 | 437,374 | 0 | 354,424,446 | 47,462,146 |
| 2026-07-01 | openai | 155 | 155 | 9,123 | 1,501,891,347 | 1,105,841,198 | 1,057,014,912 | 0 | 0 | 4,017,173 | 1,097,601 | 1,110,955,972 | 582,448,516 |
| 2026-07-02 | anthropic | 48 | 48 | 1,876 | 220,312,684 | 430,647 | 0 | 11,238,983 | 331,302,261 | 429,782 | 0 | 343,401,673 | 48,039,384 |
| 2026-06-30 | openai | 164 | 164 | 10,794 | 639,030,586 | 1,292,774,827 | 1,235,585,536 | 0 | 0 | 5,120,271 | 1,667,396 | 1,299,562,494 | 681,769,726 |
| 2026-06-29 | anthropic | 1 | 1 | 1 | 19,267,248 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 2026-06-29 | openai | 120 | 120 | 8,905 | 357,753,796 | 1,058,366,234 | 1,006,416,896 | 0 | 0 | 4,210,454 | 1,408,698 | 1,063,985,386 | 560,776,938 |
| 2026-07-04 | anthropic | 4 | 4 | 692 | 154,687,956 | 57,388 | 0 | 5,004,981 | 204,167,457 | 523,170 | 0 | 209,752,996 | 27,253,530 |
| 2026-07-04 | openai | 173 | 173 | 85,843 | 1,316,000,753 | 12,207,185,503 | 11,799,153,536 | 0 | 0 | 28,248,084 | 6,506,231 | 12,241,939,818 | 6,342,363,050 |
| 2026-07-03 | openai | 301 | 301 | 59,558 | 1,340,633,085 | 8,140,226,019 | 7,836,761,344 | 0 | 0 | 21,163,553 | 5,162,654 | 8,166,552,226 | 4,248,171,554 |
| 2026-07-02 | openai | 152 | 152 | 34,341 | 1,296,772,175 | 4,651,621,139 | 4,462,370,816 | 0 | 0 | 13,329,285 | 3,445,415 | 4,668,395,839 | 2,437,210,431 |
| 2026-07-03 | anthropic | 15 | 15 | 498 | 155,634,155 | 109,987 | 0 | 2,817,488 | 87,063,387 | 97,199 | 0 | 90,088,061 | 12,435,385 |
| TOTAL | all | 5911 | 5911 | 27,618,213 | 173,841,999,603 | 3,963,179,664,151 | 3,869,547,520,128 | 371,016,582 | 14,736,586,469 | 7,398,462,108 | 1,966,726,187 | 3,987,652,455,497 | 2,039,708,521,756 |

## Provider Token Totals

EXACT - summed directly from the per-day Anthropic and OpenAI usage rows above (each row is one date+provider; a date with both providers active contributes one row per provider).

| Provider | Raw Tokens | Billable Eq Tokens |
| --- | ---: | ---: |
| Anthropic (Claude) | 15,145,669,030 | 1,975,495,353 |
| OpenAI (Codex) | 3,972,506,786,467 | 2,037,733,026,403 |
| TOTAL | 3,987,652,455,497 | 2,039,708,521,756 |

## Estimated Token Allocation By App / Platform (derived, not measured)

The sections below are **estimates derived from git churn share, not measurements**. Claude Code / Codex session logs do not record which app or platform layer a session worked on: of the local Claude session records, the overwhelming majority run on the `main` git branch (or an auto-generated `claude/<random-name>` branch carrying no app info), and the working directory (`cwd`) recorded in nearly every session is the monorepo root rather than an app subfolder - so there is no reliable field to group real usage by app or platform. The allocation below instead spreads each day's observed raw tokens across buckets using that same day's EXACT churn share from the "Git Churn By App" / "By Platform Layer" sections. Treat it as a rough proxy for where effort likely went, not as billed or measured per-app usage.

### Estimated Token Allocation By App (derived, not measured)

**ESTIMATE - do not read as measured per-bucket token usage.** Token logs carry no app/platform attribution; these figures allocate each day's combined raw token total (Anthropic + OpenAI) across buckets in proportion to that day's EXACT git churn share (LoC added + removed) from the churn section above. A day with tokens logged but zero churn in the window falls into `Unallocated` rather than being dropped or forced into a bucket.

| App | Est. Allocated Raw Tokens | Share |
| --- | ---: | ---: |
| FreeX | 1,171,960,110,494 | 29.4 % |
| FreeW | 731,307,878,697 | 18.3 % |
| FreeP | 1,081,491,514,276 | 27.1 % |
| Shared | 49,296,809,343 | 1.2 % |
| Docs/Tooling/Other | 953,596,142,687 | 23.9 % |
| Unallocated (tokens logged, no churn that day) | 0 | 0.0 % |
| TOTAL | 3,987,652,455,497 | 100.0% |

- Days allocated (had both tokens and churn weight): 57. Days with tokens but no churn to allocate against (routed to Unallocated): 0.

### Estimated Token Allocation By Platform Layer (derived, not measured)

**ESTIMATE - do not read as measured per-bucket token usage.** Token logs carry no app/platform attribution; these figures allocate each day's combined raw token total (Anthropic + OpenAI) across buckets in proportion to that day's EXACT git churn share (LoC added + removed) from the churn section above. A day with tokens logged but zero churn in the window falls into `Unallocated` rather than being dropped or forced into a bucket.

| Platform Layer | Est. Allocated Raw Tokens | Share |
| --- | ---: | ---: |
| Windows (WPF) | 547,485,459,273 | 13.7 % |
| Avalonia (Linux/macOS) | 832,988,256,841 | 20.9 % |
| Platform-neutral (core/shared/IO/model) | 1,653,582,596,696 | 41.5 % |
| Non-code | 953,596,142,687 | 23.9 % |
| Unallocated (tokens logged, no churn that day) | 0 | 0.0 % |
| TOTAL | 3,987,652,455,497 | 100.0% |

- Days allocated (had both tokens and churn weight): 57. Days with tokens but no churn to allocate against (routed to Unallocated): 0.

## Token Extraction Notes

- Anthropic / Claude source: `~/.claude/projects/*FreeX*/**/*.jsonl` (directory names containing "FreeX", case-insensitive; includes worktree-scoped project dirs and nested subagent transcripts).
- OpenAI / Codex source: `~/.codex/sessions/**/*.jsonl` and `~/.codex/archived_sessions/*.jsonl`, filtered to sessions whose `session_meta` `cwd` contains "FreeX".
- Files/Sessions counts are distinct file/session-id counts contributing to that date+provider row. Events is the count of usage-bearing records attributed to that date.
- Bytes +/- attributes each contributing file's full size to every date on which it had at least one attributed usage event (a file spanning multiple days is counted on each of those days).
- Machines aggregated into this run's totals: ALITOP, I5-32GB.
- Per-machine `project-history-tokens-<MachineId>.json` files (tracked in git; see the multi-machine workflow note at the top of `tools/Build-ProjectHistoryMetrics.ps1`) contain ONLY: `machineId`, `generatedAt`, `startDate`, `endDate`, an `anthropic` object and an `openai` object each keyed by date with per-day `files`/`sessions`/`events`/`bytes`/`input`/`cachedInput`/`cacheWrite`/`cacheRead`/`output`/`reasoning` counts, and a static `codexNote` methodology string. No transcript content, prompts, file paths, or session titles are read or stored.

## Git Authors Observed

- 2026-05-12: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-13: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-14: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-15: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-16: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-17: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-18: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-19: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-20: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-21: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-22: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-23: Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-24: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-25: Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-26: Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-27: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-28: Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-29: Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-30: tony-xmelon <tony.xmelon@gmail.com>
- 2026-05-31: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-01: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-02: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-03: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-04: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-05: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-06: Codex <codex@local>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-07: Codex <codex@local>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-08: Codex <codex@local>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-09: Codex <codex@local>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-10: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-11: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-12: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-13: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-14: tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-15: Anton <lumodataroom@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-16: Anton <lumodataroom@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-17: Anton <lumodataroom@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-18: Anton <lumodataroom@gmail.com>; Antoni Ivanov <tony.xmelon@gmail.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-06-19: Anton <lumodataroom@gmail.com>; Antoni Ivanov <lumodataroom@gmail.com>; Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-20: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-21: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-22: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-23: Antoni Ivanov <lumodataroom@gmail.com>; Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-24: Antoni Ivanov <lumodataroom@gmail.com>; Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-25: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-26: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-27: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-06-28: Claude <noreply@anthropic.com>
- 2026-06-29: Claude <noreply@anthropic.com>
- 2026-06-30: Claude <noreply@anthropic.com>
- 2026-07-01: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-02: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-03: Claude <noreply@anthropic.com>
- 2026-07-04: Claude <noreply@anthropic.com>
- 2026-07-05: Claude <noreply@anthropic.com>
- 2026-07-06: Claude <noreply@anthropic.com>
- 2026-07-07: Claude <noreply@anthropic.com>
- 2026-07-08: Claude <noreply@anthropic.com>
- 2026-07-09: Claude <noreply@anthropic.com>
- 2026-07-10: Claude <noreply@anthropic.com>
- 2026-07-11: Claude <noreply@anthropic.com>
- 2026-07-12: Claude <noreply@anthropic.com>
- 2026-07-13: Claude <noreply@anthropic.com>
- 2026-07-14: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-15: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-16: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-17: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-18: Antoni Ivanov <tony.xmelon@gmail.com>
- 2026-07-19: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-20: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-21: Claude <noreply@anthropic.com>
- 2026-07-22: Claude <noreply@anthropic.com>
- 2026-07-23: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-24: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-25: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-26: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-27: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-28: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-07-29: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-07-30: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>; tony-xmelon <tony.xmelon@gmail.com>
- 2026-07-31: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-01: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-02: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-03: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-04: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-05: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-06: Antoni Ivanov <tony.xmelon@gmail.com>; Claude <noreply@anthropic.com>
- 2026-08-07: Claude <noreply@anthropic.com>
- 2026-08-08: Anton <lumodataroom@gmail.com>; Claude <noreply@anthropic.com>; tony-xmelon <tony.xmelon@gmail.com>

## Reading The Trend

- The daily churn table covers 2026-05-12 through 2026-08-08, computed fresh from git history reachable from HEAD (`e0878c025`) at generation time.
- Across the window: 31,931 commits, 88,879 changed-file/day entries, +6,220,527 / -2,643,561 LoC.
- Token rows reflect 173,841,999,603 bytes of local provider logs, 3,987,652,455,497 observed raw tokens, and 2,039,708,521,756 provider-style billable-equivalent tokens, from machine(s): ALITOP, I5-32GB.
- This machine (ALITOP) has contributed its token logs. Run this script on the user's other machines and copy their project-history-tokens-*.json into .metrics-data before re-running here (or there) to fold their usage into these totals.
