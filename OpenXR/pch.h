// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#pragma once

#include <memory>
#include <string>
#include <vector>
#include <thread>
#include <chrono>
#include <atomic>
#include <array>
#include <map>
#include <list>
#include <unordered_map>
#include <algorithm>
#include <assert.h>

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

#include <d3d11.h>
#include <dxgi1_2.h>

#define XR_USE_PLATFORM_WIN32
#define XR_USE_GRAPHICS_API_D3D11
#include <openxr/openxr.h>
#include <openxr/openxr_platform.h>

#include "utility/XrError.h"
#include "utility/XrExtensions.h"
#include "utility/XrHandle.h"
#include "utility/XrMath.h"
#include "utility/XrString.h"

#include <winrt/base.h> // winrt::com_ptr
#include <shlwapi.h>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <chrono>
#include <Psapi.h>

#include <Eigen/Core>
#include <Eigen/Geometry>
#include <cmath>
#include <glm/glm.hpp>
#include <glm/ext/matrix_transform.hpp>
#include <glm/gtc/matrix_access.hpp>
#include <glm/gtc/quaternion.hpp>
#include <glm/gtx/projection.hpp>

#define UNUSED(x) (void)(x)