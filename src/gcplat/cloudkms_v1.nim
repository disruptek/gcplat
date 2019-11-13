
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Key Management Service (KMS)
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages keys and performs cryptographic operations in a central cloud service, for direct use by other cloud resources and applications.
## 
## 
## https://cloud.google.com/kms/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudkms"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579635 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579637(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579636(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns metadata for a given CryptoKeyVersion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the CryptoKeyVersion to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579763 = path.getOrDefault("name")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "name", valid_579763
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns metadata for a given CryptoKeyVersion.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579635;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet
  ## Returns metadata for a given CryptoKeyVersion.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the CryptoKeyVersion to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579882, "name", newJString(name))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579635(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com", route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579636,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579637,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579923 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579925(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579924(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update a CryptoKeyVersion's metadata.
  ## 
  ## state may be changed between
  ## ENABLED and
  ## DISABLED using this
  ## method. See DestroyCryptoKeyVersion and RestoreCryptoKeyVersion to
  ## move between other states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The resource name for this CryptoKeyVersion in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*/cryptoKeyVersions/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579926 = path.getOrDefault("name")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "name", valid_579926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. List of fields to be updated in this request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("quotaUser")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "quotaUser", valid_579933
  var valid_579934 = query.getOrDefault("updateMask")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "updateMask", valid_579934
  var valid_579935 = query.getOrDefault("callback")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "callback", valid_579935
  var valid_579936 = query.getOrDefault("fields")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "fields", valid_579936
  var valid_579937 = query.getOrDefault("access_token")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "access_token", valid_579937
  var valid_579938 = query.getOrDefault("upload_protocol")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "upload_protocol", valid_579938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579940: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a CryptoKeyVersion's metadata.
  ## 
  ## state may be changed between
  ## ENABLED and
  ## DISABLED using this
  ## method. See DestroyCryptoKeyVersion and RestoreCryptoKeyVersion to
  ## move between other states.
  ## 
  let valid = call_579940.validator(path, query, header, formData, body)
  let scheme = call_579940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579940.url(scheme.get, call_579940.host, call_579940.base,
                         call_579940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579940, url, valid)

proc call*(call_579941: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579923;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch
  ## Update a CryptoKeyVersion's metadata.
  ## 
  ## state may be changed between
  ## ENABLED and
  ## DISABLED using this
  ## method. See DestroyCryptoKeyVersion and RestoreCryptoKeyVersion to
  ## move between other states.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name for this CryptoKeyVersion in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*/cryptoKeyVersions/*`.
  ##   updateMask: string
  ##             : Required. List of fields to be updated in this request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579942 = newJObject()
  var query_579943 = newJObject()
  var body_579944 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(path_579942, "name", newJString(name))
  add(query_579943, "updateMask", newJString(updateMask))
  if body != nil:
    body_579944 = body
  add(query_579943, "callback", newJString(callback))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  result = call_579941.call(path_579942, query_579943, nil, nil, body_579944)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579923(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudkms.googleapis.com",
    route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579924,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579925,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsList_579945 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsList_579947(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsList_579946(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579948 = path.getOrDefault("name")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = nil)
  if valid_579948 != nil:
    section.add "name", valid_579948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579949 = query.getOrDefault("key")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "key", valid_579949
  var valid_579950 = query.getOrDefault("prettyPrint")
  valid_579950 = validateParameter(valid_579950, JBool, required = false,
                                 default = newJBool(true))
  if valid_579950 != nil:
    section.add "prettyPrint", valid_579950
  var valid_579951 = query.getOrDefault("oauth_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "oauth_token", valid_579951
  var valid_579952 = query.getOrDefault("$.xgafv")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("1"))
  if valid_579952 != nil:
    section.add "$.xgafv", valid_579952
  var valid_579953 = query.getOrDefault("pageSize")
  valid_579953 = validateParameter(valid_579953, JInt, required = false, default = nil)
  if valid_579953 != nil:
    section.add "pageSize", valid_579953
  var valid_579954 = query.getOrDefault("alt")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("json"))
  if valid_579954 != nil:
    section.add "alt", valid_579954
  var valid_579955 = query.getOrDefault("uploadType")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "uploadType", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("filter")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "filter", valid_579957
  var valid_579958 = query.getOrDefault("pageToken")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "pageToken", valid_579958
  var valid_579959 = query.getOrDefault("callback")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "callback", valid_579959
  var valid_579960 = query.getOrDefault("fields")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "fields", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("upload_protocol")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "upload_protocol", valid_579962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579963: Call_CloudkmsProjectsLocationsList_579945; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579963.validator(path, query, header, formData, body)
  let scheme = call_579963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579963.url(scheme.get, call_579963.host, call_579963.base,
                         call_579963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579963, url, valid)

proc call*(call_579964: Call_CloudkmsProjectsLocationsList_579945; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579965 = newJObject()
  var query_579966 = newJObject()
  add(query_579966, "key", newJString(key))
  add(query_579966, "prettyPrint", newJBool(prettyPrint))
  add(query_579966, "oauth_token", newJString(oauthToken))
  add(query_579966, "$.xgafv", newJString(Xgafv))
  add(query_579966, "pageSize", newJInt(pageSize))
  add(query_579966, "alt", newJString(alt))
  add(query_579966, "uploadType", newJString(uploadType))
  add(query_579966, "quotaUser", newJString(quotaUser))
  add(path_579965, "name", newJString(name))
  add(query_579966, "filter", newJString(filter))
  add(query_579966, "pageToken", newJString(pageToken))
  add(query_579966, "callback", newJString(callback))
  add(query_579966, "fields", newJString(fields))
  add(query_579966, "access_token", newJString(accessToken))
  add(query_579966, "upload_protocol", newJString(uploadProtocol))
  result = call_579964.call(path_579965, query_579966, nil, nil, nil)

var cloudkmsProjectsLocationsList* = Call_CloudkmsProjectsLocationsList_579945(
    name: "cloudkmsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudkmsProjectsLocationsList_579946, base: "/",
    url: url_CloudkmsProjectsLocationsList_579947, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579967 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579969(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/publicKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the CryptoKeyVersion public key to
  ## get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579970 = path.getOrDefault("name")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "name", valid_579970
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("prettyPrint")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(true))
  if valid_579972 != nil:
    section.add "prettyPrint", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("$.xgafv")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("1"))
  if valid_579974 != nil:
    section.add "$.xgafv", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("callback")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "callback", valid_579978
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("access_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "access_token", valid_579980
  var valid_579981 = query.getOrDefault("upload_protocol")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "upload_protocol", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579982: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579967;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the CryptoKeyVersion public key to
  ## get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(path_579984, "name", newJString(name))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  result = call_579983.call(path_579984, query_579985, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579967(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{name}/publicKey", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579968,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_579969,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579986 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579988(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":asymmetricDecrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579987(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for
  ## decryption.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579989 = path.getOrDefault("name")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "name", valid_579989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("$.xgafv")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("1"))
  if valid_579993 != nil:
    section.add "$.xgafv", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("quotaUser")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "quotaUser", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("access_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "access_token", valid_579999
  var valid_580000 = query.getOrDefault("upload_protocol")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "upload_protocol", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580002: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579986;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for
  ## decryption.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "key", newJString(key))
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  if body != nil:
    body_580006 = body
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579986(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricDecrypt", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579987,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_579988,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580007 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580009(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":asymmetricSign")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580008(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for signing.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("access_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "access_token", valid_580020
  var valid_580021 = query.getOrDefault("upload_protocol")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "upload_protocol", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580023: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580007;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for signing.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "key", newJString(key))
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(path_580025, "name", newJString(name))
  if body != nil:
    body_580027 = body
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580007(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricSign", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580008,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580009,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580028 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580030(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":decrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580029(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKey to use for decryption.
  ## The server will choose the appropriate version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("prettyPrint")
  valid_580033 = validateParameter(valid_580033, JBool, required = false,
                                 default = newJBool(true))
  if valid_580033 != nil:
    section.add "prettyPrint", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580044: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580028;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKey to use for decryption.
  ## The server will choose the appropriate version.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "key", newJString(key))
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  if body != nil:
    body_580048 = body
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580028(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:decrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580029,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580030,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580049 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":destroy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580050(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Schedule a CryptoKeyVersion for destruction.
  ## 
  ## Upon calling this method, CryptoKeyVersion.state will be set to
  ## DESTROY_SCHEDULED
  ## and destroy_time will be set to a time 24
  ## hours in the future, at which point the state
  ## will be changed to
  ## DESTROYED, and the key
  ## material will be irrevocably destroyed.
  ## 
  ## Before the destroy_time is reached,
  ## RestoreCryptoKeyVersion may be called to reverse the process.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKeyVersion to destroy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Schedule a CryptoKeyVersion for destruction.
  ## 
  ## Upon calling this method, CryptoKeyVersion.state will be set to
  ## DESTROY_SCHEDULED
  ## and destroy_time will be set to a time 24
  ## hours in the future, at which point the state
  ## will be changed to
  ## DESTROYED, and the key
  ## material will be irrevocably destroyed.
  ## 
  ## Before the destroy_time is reached,
  ## RestoreCryptoKeyVersion may be called to reverse the process.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580049;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy
  ## Schedule a CryptoKeyVersion for destruction.
  ## 
  ## Upon calling this method, CryptoKeyVersion.state will be set to
  ## DESTROY_SCHEDULED
  ## and destroy_time will be set to a time 24
  ## hours in the future, at which point the state
  ## will be changed to
  ## DESTROYED, and the key
  ## material will be irrevocably destroyed.
  ## 
  ## Before the destroy_time is reached,
  ## RestoreCryptoKeyVersion may be called to reverse the process.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to destroy.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(query_580068, "key", newJString(key))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  if body != nil:
    body_580069 = body
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580049(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:destroy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580050,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580051,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580070 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580072(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":encrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580071(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKey or CryptoKeyVersion
  ## to use for encryption.
  ## 
  ## If a CryptoKey is specified, the server will use its
  ## primary version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("quotaUser")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "quotaUser", valid_580080
  var valid_580081 = query.getOrDefault("callback")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "callback", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580086: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580070;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKey or CryptoKeyVersion
  ## to use for encryption.
  ## 
  ## If a CryptoKey is specified, the server will use its
  ## primary version.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "key", newJString(key))
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  if body != nil:
    body_580090 = body
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580070(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:encrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580071,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580072,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580091 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580093(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580092(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Restore a CryptoKeyVersion in the
  ## DESTROY_SCHEDULED
  ## state.
  ## 
  ## Upon restoration of the CryptoKeyVersion, state
  ## will be set to DISABLED,
  ## and destroy_time will be cleared.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKeyVersion to restore.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580094 = path.getOrDefault("name")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "name", valid_580094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("$.xgafv")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("1"))
  if valid_580098 != nil:
    section.add "$.xgafv", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("uploadType")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "uploadType", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("callback")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "callback", valid_580102
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580107: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580091;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restore a CryptoKeyVersion in the
  ## DESTROY_SCHEDULED
  ## state.
  ## 
  ## Upon restoration of the CryptoKeyVersion, state
  ## will be set to DISABLED,
  ## and destroy_time will be cleared.
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580091;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore
  ## Restore a CryptoKeyVersion in the
  ## DESTROY_SCHEDULED
  ## state.
  ## 
  ## Upon restoration of the CryptoKeyVersion, state
  ## will be set to DISABLED,
  ## and destroy_time will be cleared.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to restore.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  var body_580111 = newJObject()
  add(query_580110, "key", newJString(key))
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(path_580109, "name", newJString(name))
  if body != nil:
    body_580111 = body
  add(query_580110, "callback", newJString(callback))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  result = call_580108.call(path_580109, query_580110, nil, nil, body_580111)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580091(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:restore", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580092,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580093,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580112 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580114(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updatePrimaryVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580113(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the CryptoKey to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580115 = path.getOrDefault("name")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "name", valid_580115
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(true))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("uploadType")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "uploadType", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("callback")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "callback", valid_580123
  var valid_580124 = query.getOrDefault("fields")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "fields", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("upload_protocol")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "upload_protocol", valid_580126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580128: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580112;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKey to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "key", newJString(key))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "uploadType", newJString(uploadType))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(path_580130, "name", newJString(name))
  if body != nil:
    body_580132 = body
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580112(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:updatePrimaryVersion", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580113,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580114,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580157 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580159(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580158(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the CryptoKey associated with
  ## the CryptoKeyVersions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580160 = path.getOrDefault("parent")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "parent", valid_580160
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580161 = query.getOrDefault("key")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "key", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("$.xgafv")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("1"))
  if valid_580164 != nil:
    section.add "$.xgafv", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("uploadType")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "uploadType", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("callback")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "callback", valid_580168
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("access_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "access_token", valid_580170
  var valid_580171 = query.getOrDefault("upload_protocol")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "upload_protocol", valid_580171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580157;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the CryptoKey associated with
  ## the CryptoKeyVersions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  var body_580177 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "$.xgafv", newJString(Xgafv))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "uploadType", newJString(uploadType))
  add(query_580176, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580177 = body
  add(query_580176, "callback", newJString(callback))
  add(path_580175, "parent", newJString(parent))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "access_token", newJString(accessToken))
  add(query_580176, "upload_protocol", newJString(uploadProtocol))
  result = call_580174.call(path_580175, query_580176, nil, nil, body_580177)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580157(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580158,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580159,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580133 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580135(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580134(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists CryptoKeyVersions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the CryptoKey to list, in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580136 = path.getOrDefault("parent")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "parent", valid_580136
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. Optional limit on the number of CryptoKeyVersions to
  ## include in the response. Further CryptoKeyVersions can
  ## subsequently be obtained by including the
  ## ListCryptoKeyVersionsResponse.next_page_token in a subsequent request.
  ## If unspecified, the server will pick an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: JString
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListCryptoKeyVersionsResponse.next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The fields to include in the response.
  section = newJObject()
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("pageSize")
  valid_580141 = validateParameter(valid_580141, JInt, required = false, default = nil)
  if valid_580141 != nil:
    section.add "pageSize", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("uploadType")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "uploadType", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("orderBy")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "orderBy", valid_580145
  var valid_580146 = query.getOrDefault("filter")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "filter", valid_580146
  var valid_580147 = query.getOrDefault("pageToken")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "pageToken", valid_580147
  var valid_580148 = query.getOrDefault("callback")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "callback", valid_580148
  var valid_580149 = query.getOrDefault("fields")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "fields", valid_580149
  var valid_580150 = query.getOrDefault("access_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "access_token", valid_580150
  var valid_580151 = query.getOrDefault("upload_protocol")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "upload_protocol", valid_580151
  var valid_580152 = query.getOrDefault("view")
  valid_580152 = validateParameter(valid_580152, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_580152 != nil:
    section.add "view", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeyVersions.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580133;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = "";
          view: string = "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList
  ## Lists CryptoKeyVersions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Optional limit on the number of CryptoKeyVersions to
  ## include in the response. Further CryptoKeyVersions can
  ## subsequently be obtained by including the
  ## ListCryptoKeyVersionsResponse.next_page_token in a subsequent request.
  ## If unspecified, the server will pick an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: string
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListCryptoKeyVersionsResponse.next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the CryptoKey to list, in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The fields to include in the response.
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "key", newJString(key))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "$.xgafv", newJString(Xgafv))
  add(query_580156, "pageSize", newJInt(pageSize))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "uploadType", newJString(uploadType))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "orderBy", newJString(orderBy))
  add(query_580156, "filter", newJString(filter))
  add(query_580156, "pageToken", newJString(pageToken))
  add(query_580156, "callback", newJString(callback))
  add(path_580155, "parent", newJString(parent))
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "access_token", newJString(accessToken))
  add(query_580156, "upload_protocol", newJString(uploadProtocol))
  add(query_580156, "view", newJString(view))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580133(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580134,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580135,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580178 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580180(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions:import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580179(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the CryptoKey to
  ## be imported into.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580181 = path.getOrDefault("parent")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "parent", valid_580181
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("$.xgafv")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("1"))
  if valid_580185 != nil:
    section.add "$.xgafv", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("callback")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "callback", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("access_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "access_token", valid_580191
  var valid_580192 = query.getOrDefault("upload_protocol")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "upload_protocol", valid_580192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580194: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580178;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the CryptoKey to
  ## be imported into.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  var body_580198 = newJObject()
  add(query_580197, "key", newJString(key))
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "uploadType", newJString(uploadType))
  add(query_580197, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580198 = body
  add(query_580197, "callback", newJString(callback))
  add(path_580196, "parent", newJString(parent))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  result = call_580195.call(path_580196, query_580197, nil, nil, body_580198)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580178(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions:import", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580179,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580180,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580223 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580225(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580224(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the KeyRing associated with the
  ## CryptoKeys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580226 = path.getOrDefault("parent")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "parent", valid_580226
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   cryptoKeyId: JString
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   skipInitialVersionCreation: JBool
  ##                             : If set to true, the request will create a CryptoKey without any
  ## CryptoKeyVersions. You must manually call
  ## CreateCryptoKeyVersion or
  ## ImportCryptoKeyVersion
  ## before you can use this CryptoKey.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580227 = query.getOrDefault("key")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "key", valid_580227
  var valid_580228 = query.getOrDefault("prettyPrint")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "prettyPrint", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("$.xgafv")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("1"))
  if valid_580230 != nil:
    section.add "$.xgafv", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("cryptoKeyId")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "cryptoKeyId", valid_580234
  var valid_580235 = query.getOrDefault("skipInitialVersionCreation")
  valid_580235 = validateParameter(valid_580235, JBool, required = false, default = nil)
  if valid_580235 != nil:
    section.add "skipInitialVersionCreation", valid_580235
  var valid_580236 = query.getOrDefault("callback")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "callback", valid_580236
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
  var valid_580238 = query.getOrDefault("access_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "access_token", valid_580238
  var valid_580239 = query.getOrDefault("upload_protocol")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "upload_protocol", valid_580239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580241: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  let valid = call_580241.validator(path, query, header, formData, body)
  let scheme = call_580241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580241.url(scheme.get, call_580241.host, call_580241.base,
                         call_580241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580241, url, valid)

proc call*(call_580242: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580223;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; cryptoKeyId: string = "";
          skipInitialVersionCreation: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   cryptoKeyId: string
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   skipInitialVersionCreation: bool
  ##                             : If set to true, the request will create a CryptoKey without any
  ## CryptoKeyVersions. You must manually call
  ## CreateCryptoKeyVersion or
  ## ImportCryptoKeyVersion
  ## before you can use this CryptoKey.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the KeyRing associated with the
  ## CryptoKeys.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580243 = newJObject()
  var query_580244 = newJObject()
  var body_580245 = newJObject()
  add(query_580244, "key", newJString(key))
  add(query_580244, "prettyPrint", newJBool(prettyPrint))
  add(query_580244, "oauth_token", newJString(oauthToken))
  add(query_580244, "$.xgafv", newJString(Xgafv))
  add(query_580244, "alt", newJString(alt))
  add(query_580244, "uploadType", newJString(uploadType))
  add(query_580244, "quotaUser", newJString(quotaUser))
  add(query_580244, "cryptoKeyId", newJString(cryptoKeyId))
  add(query_580244, "skipInitialVersionCreation",
      newJBool(skipInitialVersionCreation))
  if body != nil:
    body_580245 = body
  add(query_580244, "callback", newJString(callback))
  add(path_580243, "parent", newJString(parent))
  add(query_580244, "fields", newJString(fields))
  add(query_580244, "access_token", newJString(accessToken))
  add(query_580244, "upload_protocol", newJString(uploadProtocol))
  result = call_580242.call(path_580243, query_580244, nil, nil, body_580245)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580223(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580224,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580225,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580199 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580201(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580200(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists CryptoKeys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580202 = path.getOrDefault("parent")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "parent", valid_580202
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   versionView: JString
  ##              : The fields of the primary version to include in the response.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. Optional limit on the number of CryptoKeys to include in the
  ## response.  Further CryptoKeys can subsequently be obtained by
  ## including the ListCryptoKeysResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: JString
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListCryptoKeysResponse.next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("versionView")
  valid_580206 = validateParameter(valid_580206, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_580206 != nil:
    section.add "versionView", valid_580206
  var valid_580207 = query.getOrDefault("$.xgafv")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("1"))
  if valid_580207 != nil:
    section.add "$.xgafv", valid_580207
  var valid_580208 = query.getOrDefault("pageSize")
  valid_580208 = validateParameter(valid_580208, JInt, required = false, default = nil)
  if valid_580208 != nil:
    section.add "pageSize", valid_580208
  var valid_580209 = query.getOrDefault("alt")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("json"))
  if valid_580209 != nil:
    section.add "alt", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("orderBy")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "orderBy", valid_580212
  var valid_580213 = query.getOrDefault("filter")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "filter", valid_580213
  var valid_580214 = query.getOrDefault("pageToken")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "pageToken", valid_580214
  var valid_580215 = query.getOrDefault("callback")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "callback", valid_580215
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("access_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "access_token", valid_580217
  var valid_580218 = query.getOrDefault("upload_protocol")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "upload_protocol", valid_580218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580219: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeys.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580199;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = "";
          versionView: string = "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysList
  ## Lists CryptoKeys.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   versionView: string
  ##              : The fields of the primary version to include in the response.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Optional limit on the number of CryptoKeys to include in the
  ## response.  Further CryptoKeys can subsequently be obtained by
  ## including the ListCryptoKeysResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: string
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListCryptoKeysResponse.next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580221 = newJObject()
  var query_580222 = newJObject()
  add(query_580222, "key", newJString(key))
  add(query_580222, "prettyPrint", newJBool(prettyPrint))
  add(query_580222, "oauth_token", newJString(oauthToken))
  add(query_580222, "versionView", newJString(versionView))
  add(query_580222, "$.xgafv", newJString(Xgafv))
  add(query_580222, "pageSize", newJInt(pageSize))
  add(query_580222, "alt", newJString(alt))
  add(query_580222, "uploadType", newJString(uploadType))
  add(query_580222, "quotaUser", newJString(quotaUser))
  add(query_580222, "orderBy", newJString(orderBy))
  add(query_580222, "filter", newJString(filter))
  add(query_580222, "pageToken", newJString(pageToken))
  add(query_580222, "callback", newJString(callback))
  add(path_580221, "parent", newJString(parent))
  add(query_580222, "fields", newJString(fields))
  add(query_580222, "access_token", newJString(accessToken))
  add(query_580222, "upload_protocol", newJString(uploadProtocol))
  result = call_580220.call(path_580221, query_580222, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580199(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580200,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580201,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580269 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580271(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/importJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580270(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the KeyRing associated with the
  ## ImportJobs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580272 = path.getOrDefault("parent")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "parent", valid_580272
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   importJobId: JString
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  section = newJObject()
  var valid_580273 = query.getOrDefault("key")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "key", valid_580273
  var valid_580274 = query.getOrDefault("prettyPrint")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(true))
  if valid_580274 != nil:
    section.add "prettyPrint", valid_580274
  var valid_580275 = query.getOrDefault("oauth_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "oauth_token", valid_580275
  var valid_580276 = query.getOrDefault("$.xgafv")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("1"))
  if valid_580276 != nil:
    section.add "$.xgafv", valid_580276
  var valid_580277 = query.getOrDefault("alt")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = newJString("json"))
  if valid_580277 != nil:
    section.add "alt", valid_580277
  var valid_580278 = query.getOrDefault("uploadType")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "uploadType", valid_580278
  var valid_580279 = query.getOrDefault("quotaUser")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "quotaUser", valid_580279
  var valid_580280 = query.getOrDefault("callback")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "callback", valid_580280
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("access_token")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "access_token", valid_580282
  var valid_580283 = query.getOrDefault("upload_protocol")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "upload_protocol", valid_580283
  var valid_580284 = query.getOrDefault("importJobId")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "importJobId", valid_580284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580286: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  let valid = call_580286.validator(path, query, header, formData, body)
  let scheme = call_580286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580286.url(scheme.get, call_580286.host, call_580286.base,
                         call_580286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580286, url, valid)

proc call*(call_580287: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580269;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; importJobId: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsCreate
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the KeyRing associated with the
  ## ImportJobs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   importJobId: string
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  var path_580288 = newJObject()
  var query_580289 = newJObject()
  var body_580290 = newJObject()
  add(query_580289, "key", newJString(key))
  add(query_580289, "prettyPrint", newJBool(prettyPrint))
  add(query_580289, "oauth_token", newJString(oauthToken))
  add(query_580289, "$.xgafv", newJString(Xgafv))
  add(query_580289, "alt", newJString(alt))
  add(query_580289, "uploadType", newJString(uploadType))
  add(query_580289, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580290 = body
  add(query_580289, "callback", newJString(callback))
  add(path_580288, "parent", newJString(parent))
  add(query_580289, "fields", newJString(fields))
  add(query_580289, "access_token", newJString(accessToken))
  add(query_580289, "upload_protocol", newJString(uploadProtocol))
  add(query_580289, "importJobId", newJString(importJobId))
  result = call_580287.call(path_580288, query_580289, nil, nil, body_580290)

var cloudkmsProjectsLocationsKeyRingsImportJobsCreate* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580269(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580270,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580271,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580246 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsList_580248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/importJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_580247(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists ImportJobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580249 = path.getOrDefault("parent")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "parent", valid_580249
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. Optional limit on the number of ImportJobs to include in the
  ## response. Further ImportJobs can subsequently be obtained by
  ## including the ListImportJobsResponse.next_page_token in a subsequent
  ## request. If unspecified, the server will pick an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: JString
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListImportJobsResponse.next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("$.xgafv")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("1"))
  if valid_580253 != nil:
    section.add "$.xgafv", valid_580253
  var valid_580254 = query.getOrDefault("pageSize")
  valid_580254 = validateParameter(valid_580254, JInt, required = false, default = nil)
  if valid_580254 != nil:
    section.add "pageSize", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("uploadType")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "uploadType", valid_580256
  var valid_580257 = query.getOrDefault("quotaUser")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "quotaUser", valid_580257
  var valid_580258 = query.getOrDefault("orderBy")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "orderBy", valid_580258
  var valid_580259 = query.getOrDefault("filter")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "filter", valid_580259
  var valid_580260 = query.getOrDefault("pageToken")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "pageToken", valid_580260
  var valid_580261 = query.getOrDefault("callback")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "callback", valid_580261
  var valid_580262 = query.getOrDefault("fields")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "fields", valid_580262
  var valid_580263 = query.getOrDefault("access_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "access_token", valid_580263
  var valid_580264 = query.getOrDefault("upload_protocol")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "upload_protocol", valid_580264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580265: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ImportJobs.
  ## 
  let valid = call_580265.validator(path, query, header, formData, body)
  let scheme = call_580265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580265.url(scheme.get, call_580265.host, call_580265.base,
                         call_580265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580265, url, valid)

proc call*(call_580266: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580246;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsList
  ## Lists ImportJobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Optional limit on the number of ImportJobs to include in the
  ## response. Further ImportJobs can subsequently be obtained by
  ## including the ListImportJobsResponse.next_page_token in a subsequent
  ## request. If unspecified, the server will pick an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: string
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListImportJobsResponse.next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580267 = newJObject()
  var query_580268 = newJObject()
  add(query_580268, "key", newJString(key))
  add(query_580268, "prettyPrint", newJBool(prettyPrint))
  add(query_580268, "oauth_token", newJString(oauthToken))
  add(query_580268, "$.xgafv", newJString(Xgafv))
  add(query_580268, "pageSize", newJInt(pageSize))
  add(query_580268, "alt", newJString(alt))
  add(query_580268, "uploadType", newJString(uploadType))
  add(query_580268, "quotaUser", newJString(quotaUser))
  add(query_580268, "orderBy", newJString(orderBy))
  add(query_580268, "filter", newJString(filter))
  add(query_580268, "pageToken", newJString(pageToken))
  add(query_580268, "callback", newJString(callback))
  add(path_580267, "parent", newJString(parent))
  add(query_580268, "fields", newJString(fields))
  add(query_580268, "access_token", newJString(accessToken))
  add(query_580268, "upload_protocol", newJString(uploadProtocol))
  result = call_580266.call(path_580267, query_580268, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsList* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580246(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_580247,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsList_580248,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCreate_580314 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCreate_580316(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/keyRings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCreate_580315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580317 = path.getOrDefault("parent")
  valid_580317 = validateParameter(valid_580317, JString, required = true,
                                 default = nil)
  if valid_580317 != nil:
    section.add "parent", valid_580317
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   keyRingId: JString
  ##            : Required. It must be unique within a location and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("$.xgafv")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("1"))
  if valid_580321 != nil:
    section.add "$.xgafv", valid_580321
  var valid_580322 = query.getOrDefault("alt")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = newJString("json"))
  if valid_580322 != nil:
    section.add "alt", valid_580322
  var valid_580323 = query.getOrDefault("uploadType")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "uploadType", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("keyRingId")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "keyRingId", valid_580325
  var valid_580326 = query.getOrDefault("callback")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "callback", valid_580326
  var valid_580327 = query.getOrDefault("fields")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "fields", valid_580327
  var valid_580328 = query.getOrDefault("access_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "access_token", valid_580328
  var valid_580329 = query.getOrDefault("upload_protocol")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "upload_protocol", valid_580329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580331: Call_CloudkmsProjectsLocationsKeyRingsCreate_580314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  let valid = call_580331.validator(path, query, header, formData, body)
  let scheme = call_580331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580331.url(scheme.get, call_580331.host, call_580331.base,
                         call_580331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580331, url, valid)

proc call*(call_580332: Call_CloudkmsProjectsLocationsKeyRingsCreate_580314;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; keyRingId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCreate
  ## Create a new KeyRing in a given Project and Location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   keyRingId: string
  ##            : Required. It must be unique within a location and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580333 = newJObject()
  var query_580334 = newJObject()
  var body_580335 = newJObject()
  add(query_580334, "key", newJString(key))
  add(query_580334, "prettyPrint", newJBool(prettyPrint))
  add(query_580334, "oauth_token", newJString(oauthToken))
  add(query_580334, "$.xgafv", newJString(Xgafv))
  add(query_580334, "alt", newJString(alt))
  add(query_580334, "uploadType", newJString(uploadType))
  add(query_580334, "quotaUser", newJString(quotaUser))
  add(query_580334, "keyRingId", newJString(keyRingId))
  if body != nil:
    body_580335 = body
  add(query_580334, "callback", newJString(callback))
  add(path_580333, "parent", newJString(parent))
  add(query_580334, "fields", newJString(fields))
  add(query_580334, "access_token", newJString(accessToken))
  add(query_580334, "upload_protocol", newJString(uploadProtocol))
  result = call_580332.call(path_580333, query_580334, nil, nil, body_580335)

var cloudkmsProjectsLocationsKeyRingsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCreate_580314(
    name: "cloudkmsProjectsLocationsKeyRingsCreate", meth: HttpMethod.HttpPost,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCreate_580315, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCreate_580316,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsList_580291 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsList_580293(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/keyRings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsList_580292(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists KeyRings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580294 = path.getOrDefault("parent")
  valid_580294 = validateParameter(valid_580294, JString, required = true,
                                 default = nil)
  if valid_580294 != nil:
    section.add "parent", valid_580294
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. Optional limit on the number of KeyRings to include in the
  ## response.  Further KeyRings can subsequently be obtained by
  ## including the ListKeyRingsResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order.  For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: JString
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListKeyRingsResponse.next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580295 = query.getOrDefault("key")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "key", valid_580295
  var valid_580296 = query.getOrDefault("prettyPrint")
  valid_580296 = validateParameter(valid_580296, JBool, required = false,
                                 default = newJBool(true))
  if valid_580296 != nil:
    section.add "prettyPrint", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("$.xgafv")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("1"))
  if valid_580298 != nil:
    section.add "$.xgafv", valid_580298
  var valid_580299 = query.getOrDefault("pageSize")
  valid_580299 = validateParameter(valid_580299, JInt, required = false, default = nil)
  if valid_580299 != nil:
    section.add "pageSize", valid_580299
  var valid_580300 = query.getOrDefault("alt")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("json"))
  if valid_580300 != nil:
    section.add "alt", valid_580300
  var valid_580301 = query.getOrDefault("uploadType")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "uploadType", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("orderBy")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "orderBy", valid_580303
  var valid_580304 = query.getOrDefault("filter")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "filter", valid_580304
  var valid_580305 = query.getOrDefault("pageToken")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "pageToken", valid_580305
  var valid_580306 = query.getOrDefault("callback")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "callback", valid_580306
  var valid_580307 = query.getOrDefault("fields")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "fields", valid_580307
  var valid_580308 = query.getOrDefault("access_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "access_token", valid_580308
  var valid_580309 = query.getOrDefault("upload_protocol")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "upload_protocol", valid_580309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580310: Call_CloudkmsProjectsLocationsKeyRingsList_580291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists KeyRings.
  ## 
  let valid = call_580310.validator(path, query, header, formData, body)
  let scheme = call_580310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580310.url(scheme.get, call_580310.host, call_580310.base,
                         call_580310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580310, url, valid)

proc call*(call_580311: Call_CloudkmsProjectsLocationsKeyRingsList_580291;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsList
  ## Lists KeyRings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Optional limit on the number of KeyRings to include in the
  ## response.  Further KeyRings can subsequently be obtained by
  ## including the ListKeyRingsResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order.  For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   pageToken: string
  ##            : Optional. Optional pagination token, returned earlier via
  ## ListKeyRingsResponse.next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580312 = newJObject()
  var query_580313 = newJObject()
  add(query_580313, "key", newJString(key))
  add(query_580313, "prettyPrint", newJBool(prettyPrint))
  add(query_580313, "oauth_token", newJString(oauthToken))
  add(query_580313, "$.xgafv", newJString(Xgafv))
  add(query_580313, "pageSize", newJInt(pageSize))
  add(query_580313, "alt", newJString(alt))
  add(query_580313, "uploadType", newJString(uploadType))
  add(query_580313, "quotaUser", newJString(quotaUser))
  add(query_580313, "orderBy", newJString(orderBy))
  add(query_580313, "filter", newJString(filter))
  add(query_580313, "pageToken", newJString(pageToken))
  add(query_580313, "callback", newJString(callback))
  add(path_580312, "parent", newJString(parent))
  add(query_580313, "fields", newJString(fields))
  add(query_580313, "access_token", newJString(accessToken))
  add(query_580313, "upload_protocol", newJString(uploadProtocol))
  result = call_580311.call(path_580312, query_580313, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsList* = Call_CloudkmsProjectsLocationsKeyRingsList_580291(
    name: "cloudkmsProjectsLocationsKeyRingsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsList_580292, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsList_580293, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580336 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580338(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580337(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580339 = path.getOrDefault("resource")
  valid_580339 = validateParameter(valid_580339, JString, required = true,
                                 default = nil)
  if valid_580339 != nil:
    section.add "resource", valid_580339
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580340 = query.getOrDefault("key")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "key", valid_580340
  var valid_580341 = query.getOrDefault("prettyPrint")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(true))
  if valid_580341 != nil:
    section.add "prettyPrint", valid_580341
  var valid_580342 = query.getOrDefault("oauth_token")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "oauth_token", valid_580342
  var valid_580343 = query.getOrDefault("$.xgafv")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = newJString("1"))
  if valid_580343 != nil:
    section.add "$.xgafv", valid_580343
  var valid_580344 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580344 = validateParameter(valid_580344, JInt, required = false, default = nil)
  if valid_580344 != nil:
    section.add "options.requestedPolicyVersion", valid_580344
  var valid_580345 = query.getOrDefault("alt")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("json"))
  if valid_580345 != nil:
    section.add "alt", valid_580345
  var valid_580346 = query.getOrDefault("uploadType")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "uploadType", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("callback")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "callback", valid_580348
  var valid_580349 = query.getOrDefault("fields")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "fields", valid_580349
  var valid_580350 = query.getOrDefault("access_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "access_token", valid_580350
  var valid_580351 = query.getOrDefault("upload_protocol")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "upload_protocol", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580336;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580336;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "key", newJString(key))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(query_580355, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "uploadType", newJString(uploadType))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(path_580354, "resource", newJString(resource))
  add(query_580355, "callback", newJString(callback))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580336(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:getIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580337,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580338,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580356 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580358(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580357(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580359 = path.getOrDefault("resource")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "resource", valid_580359
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580360 = query.getOrDefault("key")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "key", valid_580360
  var valid_580361 = query.getOrDefault("prettyPrint")
  valid_580361 = validateParameter(valid_580361, JBool, required = false,
                                 default = newJBool(true))
  if valid_580361 != nil:
    section.add "prettyPrint", valid_580361
  var valid_580362 = query.getOrDefault("oauth_token")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "oauth_token", valid_580362
  var valid_580363 = query.getOrDefault("$.xgafv")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("1"))
  if valid_580363 != nil:
    section.add "$.xgafv", valid_580363
  var valid_580364 = query.getOrDefault("alt")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("json"))
  if valid_580364 != nil:
    section.add "alt", valid_580364
  var valid_580365 = query.getOrDefault("uploadType")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "uploadType", valid_580365
  var valid_580366 = query.getOrDefault("quotaUser")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "quotaUser", valid_580366
  var valid_580367 = query.getOrDefault("callback")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "callback", valid_580367
  var valid_580368 = query.getOrDefault("fields")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "fields", valid_580368
  var valid_580369 = query.getOrDefault("access_token")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "access_token", valid_580369
  var valid_580370 = query.getOrDefault("upload_protocol")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "upload_protocol", valid_580370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580372: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580356;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  var body_580376 = newJObject()
  add(query_580375, "key", newJString(key))
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "$.xgafv", newJString(Xgafv))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "uploadType", newJString(uploadType))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(path_580374, "resource", newJString(resource))
  if body != nil:
    body_580376 = body
  add(query_580375, "callback", newJString(callback))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "access_token", newJString(accessToken))
  add(query_580375, "upload_protocol", newJString(uploadProtocol))
  result = call_580373.call(path_580374, query_580375, nil, nil, body_580376)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580356(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:setIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580357,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580358,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580377 = ref object of OpenApiRestCall_579364
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580379(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580378(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580380 = path.getOrDefault("resource")
  valid_580380 = validateParameter(valid_580380, JString, required = true,
                                 default = nil)
  if valid_580380 != nil:
    section.add "resource", valid_580380
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  var valid_580382 = query.getOrDefault("prettyPrint")
  valid_580382 = validateParameter(valid_580382, JBool, required = false,
                                 default = newJBool(true))
  if valid_580382 != nil:
    section.add "prettyPrint", valid_580382
  var valid_580383 = query.getOrDefault("oauth_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "oauth_token", valid_580383
  var valid_580384 = query.getOrDefault("$.xgafv")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("1"))
  if valid_580384 != nil:
    section.add "$.xgafv", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("uploadType")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "uploadType", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("callback")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "callback", valid_580388
  var valid_580389 = query.getOrDefault("fields")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "fields", valid_580389
  var valid_580390 = query.getOrDefault("access_token")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "access_token", valid_580390
  var valid_580391 = query.getOrDefault("upload_protocol")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "upload_protocol", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580393: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_580393.validator(path, query, header, formData, body)
  let scheme = call_580393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580393.url(scheme.get, call_580393.host, call_580393.base,
                         call_580393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580393, url, valid)

proc call*(call_580394: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580377;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580395 = newJObject()
  var query_580396 = newJObject()
  var body_580397 = newJObject()
  add(query_580396, "key", newJString(key))
  add(query_580396, "prettyPrint", newJBool(prettyPrint))
  add(query_580396, "oauth_token", newJString(oauthToken))
  add(query_580396, "$.xgafv", newJString(Xgafv))
  add(query_580396, "alt", newJString(alt))
  add(query_580396, "uploadType", newJString(uploadType))
  add(query_580396, "quotaUser", newJString(quotaUser))
  add(path_580395, "resource", newJString(resource))
  if body != nil:
    body_580397 = body
  add(query_580396, "callback", newJString(callback))
  add(query_580396, "fields", newJString(fields))
  add(query_580396, "access_token", newJString(accessToken))
  add(query_580396, "upload_protocol", newJString(uploadProtocol))
  result = call_580394.call(path_580395, query_580396, nil, nil, body_580397)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580377(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580378,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580379,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
