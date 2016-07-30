export default () => ({
  stats: {
    chunks: false,
    chunkModules: false,
    chunkOrigins: false,
    modules: false,
    children: true,
    cached: true,

    reasons: true,
    source: true,
    errorDetails: true,

    hash: true,
    version: false,
    timings: true,
    assets: true,
  },
});
