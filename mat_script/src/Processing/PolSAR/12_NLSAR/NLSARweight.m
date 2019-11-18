function [ weight ] = NLSARweight( sim,quanSim )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
wdic = [0.049787, 0.215635, 0.233599, 0.245744, 0.255246, 0.263195, 0.270106, 0.276268, 0.281862, 0.287007,... 
    0.291787, 0.296264, 0.300485, 0.304487, 0.308297, 0.311940, 0.315435, 0.318796, 0.322038, 0.325172, 0.328208,... 
    0.331154, 0.334018, 0.336806, 0.339523, 0.342175, 0.344767, 0.347301, 0.349783, 0.352214, 0.354599, 0.356940,... 
    0.359239, 0.361498, 0.363721, 0.365908, 0.368061, 0.370182, 0.372273, 0.374334, 0.376368, 0.378375, 0.380357,... 
    0.382314, 0.384248, 0.386160, 0.388049, 0.389919, 0.391768, 0.393598, 0.395409, 0.397203, 0.398979, 0.400739,... 
    0.402483, 0.404211, 0.405924, 0.407622, 0.409307, 0.410977, 0.412635, 0.414279, 0.415912, 0.417532, 0.419140,... 
    0.420737, 0.422322, 0.423897, 0.425462, 0.427016, 0.428560, 0.430095, 0.431620, 0.433136, 0.434643, 0.436142,... 
    0.437631, 0.439113, 0.440586, 0.442052, 0.443510, 0.444960, 0.446403, 0.447839, 0.449268, 0.450690, 0.452105,... 
    0.453513, 0.454916, 0.456312, 0.457702, 0.459085, 0.460463, 0.461836, 0.463202, 0.464563, 0.465919, 0.467270,... 
    0.468615, 0.469955, 0.471291, 0.472621, 0.473947, 0.475268, 0.476584, 0.477896, 0.479204, 0.480507, 0.481806,... 
    0.483101, 0.484392, 0.485679, 0.486962, 0.488241, 0.489516, 0.490788, 0.492056, 0.493320, 0.494581, 0.495839,... 
    0.497093, 0.498344, 0.499592, 0.500836, 0.502077, 0.503316, 0.504551, 0.505783, 0.507013, 0.508239, 0.509463,... 
    0.510684, 0.511902, 0.513118, 0.514331, 0.515541, 0.516749, 0.517955, 0.519158, 0.520358, 0.521557, 0.522753,... 
    0.523946, 0.525138, 0.526327, 0.527515, 0.528700, 0.529883, 0.531064, 0.532243, 0.533420, 0.534595, 0.535768,... 
    0.536939, 0.538109, 0.539277, 0.540443, 0.541607, 0.542770, 0.543931, 0.545090, 0.546248, 0.547404, 0.548558,... 
    0.549711, 0.550863, 0.552013, 0.553161, 0.554309, 0.555454, 0.556599, 0.557742, 0.558884, 0.560024, 0.561164,... 
    0.562302, 0.563438, 0.564574, 0.565709, 0.566842, 0.567974, 0.569105, 0.570235, 0.571364, 0.572492, 0.573619,... 
    0.574745, 0.575870, 0.576994, 0.578117, 0.579239, 0.580361, 0.581481, 0.582601, 0.583719, 0.584837, 0.585954,... 
    0.587071, 0.588186, 0.589301, 0.590415, 0.591529, 0.592641, 0.593754, 0.594865, 0.595976, 0.597086, 0.598195, ...
    0.599304, 0.600413, 0.601521, 0.602628, 0.603735, 0.604841, 0.605947, 0.607052, 0.608157, 0.609261, 0.610365, ...
    0.611469, 0.612572, 0.613675, 0.614777, 0.615879, 0.616981, 0.618082, 0.619183, 0.620284, 0.621384, 0.622484, ...
    0.623584, 0.624684, 0.625783, 0.626882, 0.627981, 0.629080, 0.630178, 0.631277, 0.632375, 0.633473, 0.634571, ...
    0.635669, 0.636766, 0.637864, 0.638961, 0.640059, 0.641156, 0.642253, 0.643351, 0.644448, 0.645545, 0.646642, ...
    0.647739, 0.648837, 0.649934, 0.651031, 0.652128, 0.653226, 0.654323, 0.655421, 0.656518, 0.657616, 0.658714, ...
    0.659812, 0.660910, 0.662008, 0.663106, 0.664205, 0.665303, 0.666402, 0.667501, 0.668601, 0.669700, 0.670800, ...
    0.671900, 0.673000, 0.674101, 0.675201, 0.676302, 0.677404, 0.678505, 0.679607, 0.680709, 0.681812, 0.682915, ...
    0.684018, 0.685122, 0.686225, 0.687330, 0.688434, 0.689539, 0.690645, 0.691751, 0.692857, 0.693964, 0.695071, ...
    0.696179, 0.697287, 0.698395, 0.699504, 0.700614, 0.701724, 0.702834, 0.703945, 0.705056, 0.706169, 0.707281, ...
    0.708394, 0.709508, 0.710622, 0.711737, 0.712852, 0.713968, 0.715085, 0.716202, 0.717320, 0.718438, 0.719557, ...
    0.720677, 0.721797, 0.722918, 0.724040, 0.725162, 0.726285, 0.727409, 0.728533, 0.729658, 0.730784, 0.731910, ...
    0.733038, 0.734166, 0.735295, 0.736424, 0.737554, 0.738686, 0.739817, 0.740950, 0.742084, 0.743218, 0.744353, ...
    0.745489, 0.746626, 0.747763, 0.748902, 0.750041, 0.751181, 0.752322, 0.753464, 0.754607, 0.755751, 0.756896, ...
    0.758041, 0.759188, 0.760335, 0.761484, 0.762633, 0.763783, 0.764935, 0.766087, 0.767240, 0.768394, 0.769550, ...
    0.770706, 0.771863, 0.773022, 0.774181, 0.775341, 0.776503, 0.777666, 0.778829, 0.779994, 0.781160, 0.782327, ...
    0.783495, 0.784664, 0.785834, 0.787005, 0.788178, 0.789351, 0.790526, 0.791702, 0.792879, 0.794058, 0.795237, ...
    0.796418, 0.797600, 0.798783, 0.799967, 0.801153, 0.802340, 0.803528, 0.804717, 0.805908, 0.807100, 0.808293, ...
    0.809488, 0.810684, 0.811881, 0.813079, 0.814279, 0.815480, 0.816683, 0.817886, 0.819092, 0.820298, 0.821506, ...
    0.822715, 0.823926, 0.825138, 0.826352, 0.827567, 0.828783, 0.830001, 0.831221, 0.832442, 0.833664, 0.834888, ...
    0.836113, 0.837340, 0.838568, 0.839798, 0.841029, 0.842262, 0.843497, 0.844733, 0.845970, 0.847209, 0.848450, ...
    0.849692, 0.850936, 0.852182, 0.853429, 0.854678, 0.855928, 0.857181, 0.858434, 0.859690, 0.860947, 0.862206, ...
    0.863466, 0.864729, 0.865993, 0.867258, 0.868526, 0.869795, 0.871066, 0.872339, 0.873613, 0.874890, 0.876168, ...
    0.877448, 0.878730, 0.880013, 0.881299, 0.882586, 0.883875, 0.885166, 0.886459, 0.887754, 0.889051, 0.890350, ...
    0.891650, 0.892953, 0.894257, 0.895564, 0.896872, 0.898183, 0.899495, 0.900810, 0.902126, 0.903445, 0.904765, ...
    0.906088, 0.907412, 0.908739, 0.910068, 0.911399, 0.912732, 0.914067, 0.915404, 0.916744, 0.918085, 0.919429, ...
    0.920775, 0.922123, 0.923473, 0.924826, 0.926181, 0.927538, 0.928897, 0.930258, 0.931622, 0.932988, 0.934356, ...
    0.935727, 0.937100, 0.938475, 0.939853, 0.941233, 0.942616, 0.944000, 0.945388, 0.946777, 0.948169, 0.949564, ...
    0.950961, 0.952360, 0.953762, 0.955166, 0.956573, 0.957983, 0.959395, 0.960809, 0.962226, 0.963646, 0.965068, ...
    0.966493, 0.967920, 0.969350, 0.970783, 0.972219, 0.973657, 0.975097, 0.976541, 0.977987, 0.979436, 0.980887, ...
    0.982342, 0.983799, 0.985259, 0.986722, 0.988187, 0.989656, 0.991127, 0.992601, 0.994078, 0.995558, 0.997041, ...
    0.998527, 0.999985, 0.998495, 0.997007, 0.995521, 0.994036, 0.992552, 0.991070, 0.989590, 0.988110, 0.986632, ...
    0.985156, 0.983681, 0.982207, 0.980735, 0.979264, 0.977794, 0.976326, 0.974859, 0.973393, 0.971929, 0.970466, ...
    0.969004, 0.967544, 0.966085, 0.964627, 0.963170, 0.961715, 0.960261, 0.958808, 0.957356, 0.955906, 0.954456, ...
    0.953008, 0.951562, 0.950116, 0.948671, 0.947228, 0.945786, 0.944345, 0.942905, 0.941466, 0.940029, 0.938592, ...
    0.937157, 0.935723, 0.934290, 0.932858, 0.931427, 0.929997, 0.928568, 0.927140, 0.925713, 0.924287, 0.922863, ...
    0.921439, 0.920016, 0.918595, 0.917174, 0.915754, 0.914335, 0.912918, 0.911501, 0.910085, 0.908670, 0.907256, ...
    0.905843, 0.904431, 0.903019, 0.901609, 0.900200, 0.898791, 0.897383, 0.895977, 0.894571, 0.893165, 0.891761, ...
    0.890358, 0.888955, 0.887553, 0.886152, 0.884752, 0.883353, 0.881954, 0.880557, 0.879160, 0.877763, 0.876368, ...
    0.874973, 0.873579, 0.872186, 0.870793, 0.869401, 0.868010, 0.866620, 0.865230, 0.863841, 0.862452, 0.861065, ...
    0.859678, 0.858291, 0.856905, 0.855520, 0.854136, 0.852752, 0.851369, 0.849986, 0.848604, 0.847222, 0.845841, ...
    0.844461, 0.843081, 0.841702, 0.840323, 0.838945, 0.837568, 0.836190, 0.834814, 0.833438, 0.832062, 0.830687, ...
    0.829312, 0.827938, 0.826564, 0.825191, 0.823818, 0.822446, 0.821074, 0.819703, 0.818331, 0.816961, 0.815590, ...
    0.814221, 0.812851, 0.811482, 0.810113, 0.808745, 0.807377, 0.806009, 0.804641, 0.803274, 0.801907, 0.800541, ...
    0.799175, 0.797809, 0.796443, 0.795078, 0.793713, 0.792348, 0.790983, 0.789619, 0.788254, 0.786890, 0.785527, ...
    0.784163, 0.782800, 0.781437, 0.780074, 0.778711, 0.777348, 0.775985, 0.774623, 0.773261, 0.771898, 0.770536, ...
    0.769174, 0.767812, 0.766451, 0.765089, 0.763727, 0.762366, 0.761004, 0.759642, 0.758281, 0.756919, 0.755558, ...
    0.754196, 0.752835, 0.751473, 0.750111, 0.748750, 0.747388, 0.746026, 0.744664, 0.743303, 0.741940, 0.740578, ...
    0.739216, 0.737854, 0.736491, 0.735128, 0.733766, 0.732403, 0.731040, 0.729676, 0.728313, 0.726949, 0.725585, ...
    0.724221, 0.722856, 0.721491, 0.720126, 0.718761, 0.717396, 0.716030, 0.714664, 0.713297, 0.711930, 0.710563, ...
    0.709196, 0.707828, 0.706460, 0.705091, 0.703722, 0.702353, 0.700983, 0.699613, 0.698242, 0.696871, 0.695499, ...
    0.694127, 0.692754, 0.691381, 0.690007, 0.688633, 0.687258, 0.685883, 0.684507, 0.683131, 0.681754, 0.680376, ...
    0.678998, 0.677619, 0.676239, 0.674859, 0.673478, 0.672096, 0.670714, 0.669331, 0.667947, 0.666562, 0.665177, ...
    0.663791, 0.662404, 0.661016, 0.659627, 0.658238, 0.656848, 0.655457, 0.654065, 0.652672, 0.651278, 0.649883, ...
    0.648487, 0.647091, 0.645693, 0.644294, 0.642895, 0.641494, 0.640092, 0.638689, 0.637285, 0.635880, 0.634474, ...
    0.633067, 0.631659, 0.630249, 0.628838, 0.627426, 0.626013, 0.624598, 0.623183, 0.621766, 0.620347, 0.618928, ...
    0.617506, 0.616084, 0.614660, 0.613235, 0.611808, 0.610380, 0.608951, 0.607520, 0.606087, 0.604653, 0.603217, ...
    0.601780, 0.600341, 0.598901, 0.597459, 0.596015, 0.594569, 0.593122, 0.591673, 0.590222, 0.588770, 0.587315, ...
    0.585859, 0.584401, 0.582941, 0.581479, 0.580015, 0.578549, 0.577081, 0.575611, 0.574139, 0.572665, 0.571189, ...
    0.569711, 0.568230, 0.566747, 0.565262, 0.563775, 0.562285, 0.560793, 0.559298, 0.557802, 0.556302, 0.554800, ...
    0.553296, 0.551789, 0.550280, 0.548768, 0.547253, 0.545736, 0.544215, 0.542692, 0.541167, 0.539638, 0.538106, ...
    0.536572, 0.535034, 0.533494, 0.531950, 0.530403, 0.528853, 0.527300, 0.525744, 0.524184, 0.522621, 0.521055, ...
    0.519485, 0.517912, 0.516335, 0.514754, 0.513170, 0.511582, 0.509990, 0.508395, 0.506795, 0.505192, 0.503584, ...
    0.501973, 0.500357, 0.498738, 0.497114, 0.495485, 0.493852, 0.492215, 0.490573, 0.488927, 0.487276, 0.485620, ...
    0.483960, 0.482294, 0.480623, 0.478948, 0.477267, 0.475581, 0.473890, 0.472193, 0.470491, 0.468783, 0.467069, ...
    0.465350, 0.463625, 0.461893, 0.460156, 0.458412, 0.456663, 0.454906, 0.453143, 0.451374, 0.449597, 0.447814, ...
    0.446024, 0.444226, 0.442422, 0.440609, 0.438790, 0.436962, 0.435127, 0.433283, 0.431431, 0.429571, 0.427703, ...
    0.425825, 0.423939, 0.422044, 0.420139, 0.418225, 0.416302, 0.414368, 0.412425, 0.410471, 0.408506, 0.406531, ...
    0.404545, 0.402548, 0.400539, 0.398518, 0.396485, 0.394440, 0.392382, 0.390311, 0.388227, 0.386129, 0.384017, ...
    0.381891, 0.379750, 0.377594, 0.375422, 0.373235, 0.371031, 0.368810, 0.366572, 0.364316, 0.362041, 0.359748, ...
    0.357435, 0.355102, 0.352748, 0.350372, 0.347975, 0.345555, 0.343111, 0.340642, 0.338148, 0.335628, 0.333081, ...
    0.330505, 0.327901, 0.325265, 0.322598, 0.319898, 0.317164, 0.314393, 0.311585, 0.308738, 0.305850, 0.302920, ...
    0.299944, 0.296921, 0.293848, 0.290722, 0.287541, 0.284302, 0.281001, 0.277634, 0.274197, 0.270686, 0.267094, ...
    0.263418, 0.259649, 0.255782, 0.251808, 0.247717, 0.243500, 0.239143, 0.234634, 0.229955, 0.225086, 0.220005, ...
    0.214683, 0.209084, 0.203165, 0.196869, 0.190123, 0.182826, 0.174836, 0.165943, 0.155815, 0.143861, 0.128864, 0.107375, 0.000000];


weight = zeros(size(sim));



for i = 1:length(wdic)-1
    
    weight = weight + wdic(i).*((sim>=quanSim(i))&(sim<quanSim(i+1)));
    
end

end
