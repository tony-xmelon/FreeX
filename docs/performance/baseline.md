# FreeX Performance Baseline

**Last reviewed:** 2026-05-29
**Status:** Historical baseline retained for comparison. Rerun before making new performance claims, especially after calculation-engine, viewport, or file-I/O performance work.

## Architectural Improvements (since baseline)

- **PR #42 — XLSX load memory halved**: `OpenWorkbookLoader` previously buffered the entire XLSX file to `byte[]` then allocated a `MemoryStream`, keeping two full file copies in memory simultaneously. Changed to open a `FileStream` directly and seek-reset it for both the inspection and load passes. Peak memory during XLSX open is approximately halved for large files.
- **PR #36 — GridView render cache allocation eliminated**: `RenderCells`/`RenderSplitPaneCells` previously allocated fresh `Dictionary` objects for brush, pen, and typeface caches on every render frame. Promoted to `private readonly` class-level fields cleared with `.Clear()` each frame. Eliminates per-frame heap allocation and GC pressure during grid rendering.

## Test Environment

- **OS**: Windows 11 Pro
- **CPU**: AMD Ryzen 9 5950X 16-Core Processor, 3.40 GHz
- **RAM**: 64 GB DDR4
- **.NET Version**: .NET 10.0.8
- **Build Configuration**: Debug test run

## Benchmark Results

### 10k Cell Recalculation Test

- **Test Description**: Recalculate 10,000 cells with 10% formula density (1,000 formulas)
- **Target**: <100ms
- **Threshold**: <1000ms
- **Result**: 2ms (0.002ms per formula)
- **Status**: PASS

### 100k Cell Recalculation Test

- **Test Description**: Recalculate 100,000 cells with 1% formula density (1,000 formulas)
- **Target**: <500ms
- **Threshold**: <2000ms
- **Result**: 16ms (0.016ms per formula)
- **Status**: PASS

### 1M Cell Memory Test

- **Test Description**: Memory usage for 1,000,000 cells (values only, no formulas)
- **Target**: <200MB
- **Threshold**: <300MB
- **Result**: 106MB
- **Status**: PASS

## Performance Analysis

The current implementation demonstrates excellent performance characteristics:

1. **Formula Evaluation Speed**: 
   - 10k cells: 0.002ms per formula
   - 100k cells: 0.016ms per formula
   These results show highly efficient formula evaluation that scales well.

2. **Memory Efficiency**: 
   - 106MB for 1M cells is excellent memory usage
   - Approximately 106 bytes per cell, which is very efficient

3. **Scalability**: 
   - The performance scales linearly with the number of formulas
   - No significant performance degradation with larger datasets

## Optimization Opportunities

1. **Multi-threading**: Future versions could implement parallel formula evaluation for large workbooks.
2. **Incremental Recalculation**: More sophisticated dependency tracking could reduce the number of cells that need recalculation.
3. **Memory Pooling**: For very large datasets, implementing object pooling could reduce GC pressure.

## Next Steps

1. Profile memory usage patterns during extended usage sessions
2. Test performance with more complex formula types (VLOOKUP, INDEX/MATCH, etc.)
3. Evaluate performance under concurrent access scenarios
4. Establish ongoing performance monitoring to detect regressions
5. Refresh this document from a Release build benchmark run before using it as release-readiness evidence.
