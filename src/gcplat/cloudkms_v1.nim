
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudkms"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns metadata for a given CryptoKeyVersion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the CryptoKeyVersion to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns metadata for a given CryptoKeyVersion.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet
  ## Returns metadata for a given CryptoKeyVersion.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the CryptoKeyVersion to get.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597677(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com", route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597678,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_597679,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597965 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597967(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597966(
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
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required list of fields to be updated in this request.
  section = newJObject()
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  var valid_597980 = query.getOrDefault("updateMask")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "updateMask", valid_597980
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

proc call*(call_597982: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597965;
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
  let valid = call_597982.validator(path, query, header, formData, body)
  let scheme = call_597982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597982.url(scheme.get, call_597982.host, call_597982.base,
                         call_597982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597982, url, valid)

proc call*(call_597983: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch
  ## Update a CryptoKeyVersion's metadata.
  ## 
  ## state may be changed between
  ## ENABLED and
  ## DISABLED using this
  ## method. See DestroyCryptoKeyVersion and RestoreCryptoKeyVersion to
  ## move between other states.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name for this CryptoKeyVersion in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*/cryptoKeyVersions/*`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required list of fields to be updated in this request.
  var path_597984 = newJObject()
  var query_597985 = newJObject()
  var body_597986 = newJObject()
  add(query_597985, "upload_protocol", newJString(uploadProtocol))
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(path_597984, "name", newJString(name))
  add(query_597985, "alt", newJString(alt))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "callback", newJString(callback))
  add(query_597985, "access_token", newJString(accessToken))
  add(query_597985, "uploadType", newJString(uploadType))
  add(query_597985, "key", newJString(key))
  add(query_597985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597986 = body
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  add(query_597985, "updateMask", newJString(updateMask))
  result = call_597983.call(path_597984, query_597985, nil, nil, body_597986)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597965(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudkms.googleapis.com",
    route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597966,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_597967,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsList_597987 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsList_597989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsList_597988(path: JsonNode; query: JsonNode;
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
  var valid_597990 = path.getOrDefault("name")
  valid_597990 = validateParameter(valid_597990, JString, required = true,
                                 default = nil)
  if valid_597990 != nil:
    section.add "name", valid_597990
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_597991 = query.getOrDefault("upload_protocol")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "upload_protocol", valid_597991
  var valid_597992 = query.getOrDefault("fields")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "fields", valid_597992
  var valid_597993 = query.getOrDefault("pageToken")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "pageToken", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("oauth_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "oauth_token", valid_597996
  var valid_597997 = query.getOrDefault("callback")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "callback", valid_597997
  var valid_597998 = query.getOrDefault("access_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "access_token", valid_597998
  var valid_597999 = query.getOrDefault("uploadType")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "uploadType", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("$.xgafv")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("1"))
  if valid_598001 != nil:
    section.add "$.xgafv", valid_598001
  var valid_598002 = query.getOrDefault("pageSize")
  valid_598002 = validateParameter(valid_598002, JInt, required = false, default = nil)
  if valid_598002 != nil:
    section.add "pageSize", valid_598002
  var valid_598003 = query.getOrDefault("prettyPrint")
  valid_598003 = validateParameter(valid_598003, JBool, required = false,
                                 default = newJBool(true))
  if valid_598003 != nil:
    section.add "prettyPrint", valid_598003
  var valid_598004 = query.getOrDefault("filter")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "filter", valid_598004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598005: Call_CloudkmsProjectsLocationsList_597987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598005.validator(path, query, header, formData, body)
  let scheme = call_598005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598005.url(scheme.get, call_598005.host, call_598005.base,
                         call_598005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598005, url, valid)

proc call*(call_598006: Call_CloudkmsProjectsLocationsList_597987; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudkmsProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_598007 = newJObject()
  var query_598008 = newJObject()
  add(query_598008, "upload_protocol", newJString(uploadProtocol))
  add(query_598008, "fields", newJString(fields))
  add(query_598008, "pageToken", newJString(pageToken))
  add(query_598008, "quotaUser", newJString(quotaUser))
  add(path_598007, "name", newJString(name))
  add(query_598008, "alt", newJString(alt))
  add(query_598008, "oauth_token", newJString(oauthToken))
  add(query_598008, "callback", newJString(callback))
  add(query_598008, "access_token", newJString(accessToken))
  add(query_598008, "uploadType", newJString(uploadType))
  add(query_598008, "key", newJString(key))
  add(query_598008, "$.xgafv", newJString(Xgafv))
  add(query_598008, "pageSize", newJInt(pageSize))
  add(query_598008, "prettyPrint", newJBool(prettyPrint))
  add(query_598008, "filter", newJString(filter))
  result = call_598006.call(path_598007, query_598008, nil, nil, nil)

var cloudkmsProjectsLocationsList* = Call_CloudkmsProjectsLocationsList_597987(
    name: "cloudkmsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudkmsProjectsLocationsList_597988, base: "/",
    url: url_CloudkmsProjectsLocationsList_597989, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598009 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598011(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/publicKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598010(
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
  ##       : The name of the CryptoKeyVersion public key to
  ## get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598012 = path.getOrDefault("name")
  valid_598012 = validateParameter(valid_598012, JString, required = true,
                                 default = nil)
  if valid_598012 != nil:
    section.add "name", valid_598012
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598013 = query.getOrDefault("upload_protocol")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "upload_protocol", valid_598013
  var valid_598014 = query.getOrDefault("fields")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "fields", valid_598014
  var valid_598015 = query.getOrDefault("quotaUser")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "quotaUser", valid_598015
  var valid_598016 = query.getOrDefault("alt")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("json"))
  if valid_598016 != nil:
    section.add "alt", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("callback")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "callback", valid_598018
  var valid_598019 = query.getOrDefault("access_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "access_token", valid_598019
  var valid_598020 = query.getOrDefault("uploadType")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "uploadType", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("$.xgafv")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = newJString("1"))
  if valid_598022 != nil:
    section.add "$.xgafv", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598024: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598009;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the CryptoKeyVersion public key to
  ## get.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(path_598026, "name", newJString(name))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  result = call_598025.call(path_598026, query_598027, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598009(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{name}/publicKey", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598010,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_598011,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598028 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598030(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":asymmetricDecrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598029(
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
  var valid_598031 = path.getOrDefault("name")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "name", valid_598031
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598032 = query.getOrDefault("upload_protocol")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "upload_protocol", valid_598032
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("oauth_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "oauth_token", valid_598036
  var valid_598037 = query.getOrDefault("callback")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "callback", valid_598037
  var valid_598038 = query.getOrDefault("access_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "access_token", valid_598038
  var valid_598039 = query.getOrDefault("uploadType")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "uploadType", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("$.xgafv")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("1"))
  if valid_598041 != nil:
    section.add "$.xgafv", valid_598041
  var valid_598042 = query.getOrDefault("prettyPrint")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "prettyPrint", valid_598042
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

proc call*(call_598044: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_598044.validator(path, query, header, formData, body)
  let scheme = call_598044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598044.url(scheme.get, call_598044.host, call_598044.base,
                         call_598044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598044, url, valid)

proc call*(call_598045: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for
  ## decryption.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598046 = newJObject()
  var query_598047 = newJObject()
  var body_598048 = newJObject()
  add(query_598047, "upload_protocol", newJString(uploadProtocol))
  add(query_598047, "fields", newJString(fields))
  add(query_598047, "quotaUser", newJString(quotaUser))
  add(path_598046, "name", newJString(name))
  add(query_598047, "alt", newJString(alt))
  add(query_598047, "oauth_token", newJString(oauthToken))
  add(query_598047, "callback", newJString(callback))
  add(query_598047, "access_token", newJString(accessToken))
  add(query_598047, "uploadType", newJString(uploadType))
  add(query_598047, "key", newJString(key))
  add(query_598047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598048 = body
  add(query_598047, "prettyPrint", newJBool(prettyPrint))
  result = call_598045.call(path_598046, query_598047, nil, nil, body_598048)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598028(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricDecrypt", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598029,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_598030,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598049 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598051(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":asymmetricSign")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598050(
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
  var valid_598052 = path.getOrDefault("name")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "name", valid_598052
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598053 = query.getOrDefault("upload_protocol")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "upload_protocol", valid_598053
  var valid_598054 = query.getOrDefault("fields")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "fields", valid_598054
  var valid_598055 = query.getOrDefault("quotaUser")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "quotaUser", valid_598055
  var valid_598056 = query.getOrDefault("alt")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("json"))
  if valid_598056 != nil:
    section.add "alt", valid_598056
  var valid_598057 = query.getOrDefault("oauth_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "oauth_token", valid_598057
  var valid_598058 = query.getOrDefault("callback")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "callback", valid_598058
  var valid_598059 = query.getOrDefault("access_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "access_token", valid_598059
  var valid_598060 = query.getOrDefault("uploadType")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "uploadType", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("$.xgafv")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = newJString("1"))
  if valid_598062 != nil:
    section.add "$.xgafv", valid_598062
  var valid_598063 = query.getOrDefault("prettyPrint")
  valid_598063 = validateParameter(valid_598063, JBool, required = false,
                                 default = newJBool(true))
  if valid_598063 != nil:
    section.add "prettyPrint", valid_598063
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

proc call*(call_598065: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  let valid = call_598065.validator(path, query, header, formData, body)
  let scheme = call_598065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598065.url(scheme.get, call_598065.host, call_598065.base,
                         call_598065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598065, url, valid)

proc call*(call_598066: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKeyVersion to use for signing.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598067 = newJObject()
  var query_598068 = newJObject()
  var body_598069 = newJObject()
  add(query_598068, "upload_protocol", newJString(uploadProtocol))
  add(query_598068, "fields", newJString(fields))
  add(query_598068, "quotaUser", newJString(quotaUser))
  add(path_598067, "name", newJString(name))
  add(query_598068, "alt", newJString(alt))
  add(query_598068, "oauth_token", newJString(oauthToken))
  add(query_598068, "callback", newJString(callback))
  add(query_598068, "access_token", newJString(accessToken))
  add(query_598068, "uploadType", newJString(uploadType))
  add(query_598068, "key", newJString(key))
  add(query_598068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598069 = body
  add(query_598068, "prettyPrint", newJBool(prettyPrint))
  result = call_598066.call(path_598067, query_598068, nil, nil, body_598069)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598049(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricSign", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598050,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_598051,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598070 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598072(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":decrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598071(
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
  var valid_598073 = path.getOrDefault("name")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "name", valid_598073
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598074 = query.getOrDefault("upload_protocol")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "upload_protocol", valid_598074
  var valid_598075 = query.getOrDefault("fields")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "fields", valid_598075
  var valid_598076 = query.getOrDefault("quotaUser")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "quotaUser", valid_598076
  var valid_598077 = query.getOrDefault("alt")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("json"))
  if valid_598077 != nil:
    section.add "alt", valid_598077
  var valid_598078 = query.getOrDefault("oauth_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "oauth_token", valid_598078
  var valid_598079 = query.getOrDefault("callback")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "callback", valid_598079
  var valid_598080 = query.getOrDefault("access_token")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "access_token", valid_598080
  var valid_598081 = query.getOrDefault("uploadType")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "uploadType", valid_598081
  var valid_598082 = query.getOrDefault("key")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "key", valid_598082
  var valid_598083 = query.getOrDefault("$.xgafv")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("1"))
  if valid_598083 != nil:
    section.add "$.xgafv", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
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

proc call*(call_598086: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  let valid = call_598086.validator(path, query, header, formData, body)
  let scheme = call_598086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598086.url(scheme.get, call_598086.host, call_598086.base,
                         call_598086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598086, url, valid)

proc call*(call_598087: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598070;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKey to use for decryption.
  ## The server will choose the appropriate version.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598088 = newJObject()
  var query_598089 = newJObject()
  var body_598090 = newJObject()
  add(query_598089, "upload_protocol", newJString(uploadProtocol))
  add(query_598089, "fields", newJString(fields))
  add(query_598089, "quotaUser", newJString(quotaUser))
  add(path_598088, "name", newJString(name))
  add(query_598089, "alt", newJString(alt))
  add(query_598089, "oauth_token", newJString(oauthToken))
  add(query_598089, "callback", newJString(callback))
  add(query_598089, "access_token", newJString(accessToken))
  add(query_598089, "uploadType", newJString(uploadType))
  add(query_598089, "key", newJString(key))
  add(query_598089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598090 = body
  add(query_598089, "prettyPrint", newJBool(prettyPrint))
  result = call_598087.call(path_598088, query_598089, nil, nil, body_598090)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598070(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:decrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598071,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_598072,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598091 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598093(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":destroy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598092(
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
  ##       : The resource name of the CryptoKeyVersion to destroy.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598094 = path.getOrDefault("name")
  valid_598094 = validateParameter(valid_598094, JString, required = true,
                                 default = nil)
  if valid_598094 != nil:
    section.add "name", valid_598094
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598095 = query.getOrDefault("upload_protocol")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "upload_protocol", valid_598095
  var valid_598096 = query.getOrDefault("fields")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "fields", valid_598096
  var valid_598097 = query.getOrDefault("quotaUser")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "quotaUser", valid_598097
  var valid_598098 = query.getOrDefault("alt")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = newJString("json"))
  if valid_598098 != nil:
    section.add "alt", valid_598098
  var valid_598099 = query.getOrDefault("oauth_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "oauth_token", valid_598099
  var valid_598100 = query.getOrDefault("callback")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "callback", valid_598100
  var valid_598101 = query.getOrDefault("access_token")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "access_token", valid_598101
  var valid_598102 = query.getOrDefault("uploadType")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "uploadType", valid_598102
  var valid_598103 = query.getOrDefault("key")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "key", valid_598103
  var valid_598104 = query.getOrDefault("$.xgafv")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = newJString("1"))
  if valid_598104 != nil:
    section.add "$.xgafv", valid_598104
  var valid_598105 = query.getOrDefault("prettyPrint")
  valid_598105 = validateParameter(valid_598105, JBool, required = false,
                                 default = newJBool(true))
  if valid_598105 != nil:
    section.add "prettyPrint", valid_598105
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

proc call*(call_598107: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598091;
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
  let valid = call_598107.validator(path, query, header, formData, body)
  let scheme = call_598107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598107.url(scheme.get, call_598107.host, call_598107.base,
                         call_598107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598107, url, valid)

proc call*(call_598108: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598091;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the CryptoKeyVersion to destroy.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598109 = newJObject()
  var query_598110 = newJObject()
  var body_598111 = newJObject()
  add(query_598110, "upload_protocol", newJString(uploadProtocol))
  add(query_598110, "fields", newJString(fields))
  add(query_598110, "quotaUser", newJString(quotaUser))
  add(path_598109, "name", newJString(name))
  add(query_598110, "alt", newJString(alt))
  add(query_598110, "oauth_token", newJString(oauthToken))
  add(query_598110, "callback", newJString(callback))
  add(query_598110, "access_token", newJString(accessToken))
  add(query_598110, "uploadType", newJString(uploadType))
  add(query_598110, "key", newJString(key))
  add(query_598110, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598111 = body
  add(query_598110, "prettyPrint", newJBool(prettyPrint))
  result = call_598108.call(path_598109, query_598110, nil, nil, body_598111)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598091(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:destroy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598092,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_598093,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598112 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598114(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":encrypt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598113(
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
  var valid_598115 = path.getOrDefault("name")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "name", valid_598115
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598116 = query.getOrDefault("upload_protocol")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "upload_protocol", valid_598116
  var valid_598117 = query.getOrDefault("fields")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "fields", valid_598117
  var valid_598118 = query.getOrDefault("quotaUser")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "quotaUser", valid_598118
  var valid_598119 = query.getOrDefault("alt")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = newJString("json"))
  if valid_598119 != nil:
    section.add "alt", valid_598119
  var valid_598120 = query.getOrDefault("oauth_token")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "oauth_token", valid_598120
  var valid_598121 = query.getOrDefault("callback")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "callback", valid_598121
  var valid_598122 = query.getOrDefault("access_token")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "access_token", valid_598122
  var valid_598123 = query.getOrDefault("uploadType")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "uploadType", valid_598123
  var valid_598124 = query.getOrDefault("key")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "key", valid_598124
  var valid_598125 = query.getOrDefault("$.xgafv")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = newJString("1"))
  if valid_598125 != nil:
    section.add "$.xgafv", valid_598125
  var valid_598126 = query.getOrDefault("prettyPrint")
  valid_598126 = validateParameter(valid_598126, JBool, required = false,
                                 default = newJBool(true))
  if valid_598126 != nil:
    section.add "prettyPrint", valid_598126
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

proc call*(call_598128: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  let valid = call_598128.validator(path, query, header, formData, body)
  let scheme = call_598128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598128.url(scheme.get, call_598128.host, call_598128.base,
                         call_598128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598128, url, valid)

proc call*(call_598129: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598112;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the CryptoKey or CryptoKeyVersion
  ## to use for encryption.
  ## 
  ## If a CryptoKey is specified, the server will use its
  ## primary version.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598130 = newJObject()
  var query_598131 = newJObject()
  var body_598132 = newJObject()
  add(query_598131, "upload_protocol", newJString(uploadProtocol))
  add(query_598131, "fields", newJString(fields))
  add(query_598131, "quotaUser", newJString(quotaUser))
  add(path_598130, "name", newJString(name))
  add(query_598131, "alt", newJString(alt))
  add(query_598131, "oauth_token", newJString(oauthToken))
  add(query_598131, "callback", newJString(callback))
  add(query_598131, "access_token", newJString(accessToken))
  add(query_598131, "uploadType", newJString(uploadType))
  add(query_598131, "key", newJString(key))
  add(query_598131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598132 = body
  add(query_598131, "prettyPrint", newJBool(prettyPrint))
  result = call_598129.call(path_598130, query_598131, nil, nil, body_598132)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598112(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:encrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598113,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_598114,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598133 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598135(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598134(
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
  ##       : The resource name of the CryptoKeyVersion to restore.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598136 = path.getOrDefault("name")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = nil)
  if valid_598136 != nil:
    section.add "name", valid_598136
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598137 = query.getOrDefault("upload_protocol")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "upload_protocol", valid_598137
  var valid_598138 = query.getOrDefault("fields")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "fields", valid_598138
  var valid_598139 = query.getOrDefault("quotaUser")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "quotaUser", valid_598139
  var valid_598140 = query.getOrDefault("alt")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("json"))
  if valid_598140 != nil:
    section.add "alt", valid_598140
  var valid_598141 = query.getOrDefault("oauth_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "oauth_token", valid_598141
  var valid_598142 = query.getOrDefault("callback")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "callback", valid_598142
  var valid_598143 = query.getOrDefault("access_token")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "access_token", valid_598143
  var valid_598144 = query.getOrDefault("uploadType")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "uploadType", valid_598144
  var valid_598145 = query.getOrDefault("key")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "key", valid_598145
  var valid_598146 = query.getOrDefault("$.xgafv")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = newJString("1"))
  if valid_598146 != nil:
    section.add "$.xgafv", valid_598146
  var valid_598147 = query.getOrDefault("prettyPrint")
  valid_598147 = validateParameter(valid_598147, JBool, required = false,
                                 default = newJBool(true))
  if valid_598147 != nil:
    section.add "prettyPrint", valid_598147
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

proc call*(call_598149: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598133;
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
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598133;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore
  ## Restore a CryptoKeyVersion in the
  ## DESTROY_SCHEDULED
  ## state.
  ## 
  ## Upon restoration of the CryptoKeyVersion, state
  ## will be set to DISABLED,
  ## and destroy_time will be cleared.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the CryptoKeyVersion to restore.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598151 = newJObject()
  var query_598152 = newJObject()
  var body_598153 = newJObject()
  add(query_598152, "upload_protocol", newJString(uploadProtocol))
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(path_598151, "name", newJString(name))
  add(query_598152, "alt", newJString(alt))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(query_598152, "callback", newJString(callback))
  add(query_598152, "access_token", newJString(accessToken))
  add(query_598152, "uploadType", newJString(uploadType))
  add(query_598152, "key", newJString(key))
  add(query_598152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598153 = body
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(path_598151, query_598152, nil, nil, body_598153)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598133(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:restore", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598134,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_598135,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598154 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598156(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updatePrimaryVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598155(
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
  ##       : The resource name of the CryptoKey to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598157 = path.getOrDefault("name")
  valid_598157 = validateParameter(valid_598157, JString, required = true,
                                 default = nil)
  if valid_598157 != nil:
    section.add "name", valid_598157
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598158 = query.getOrDefault("upload_protocol")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "upload_protocol", valid_598158
  var valid_598159 = query.getOrDefault("fields")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "fields", valid_598159
  var valid_598160 = query.getOrDefault("quotaUser")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "quotaUser", valid_598160
  var valid_598161 = query.getOrDefault("alt")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("json"))
  if valid_598161 != nil:
    section.add "alt", valid_598161
  var valid_598162 = query.getOrDefault("oauth_token")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "oauth_token", valid_598162
  var valid_598163 = query.getOrDefault("callback")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "callback", valid_598163
  var valid_598164 = query.getOrDefault("access_token")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "access_token", valid_598164
  var valid_598165 = query.getOrDefault("uploadType")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "uploadType", valid_598165
  var valid_598166 = query.getOrDefault("key")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "key", valid_598166
  var valid_598167 = query.getOrDefault("$.xgafv")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = newJString("1"))
  if valid_598167 != nil:
    section.add "$.xgafv", valid_598167
  var valid_598168 = query.getOrDefault("prettyPrint")
  valid_598168 = validateParameter(valid_598168, JBool, required = false,
                                 default = newJBool(true))
  if valid_598168 != nil:
    section.add "prettyPrint", valid_598168
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

proc call*(call_598170: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598154;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the CryptoKey to update.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  var body_598174 = newJObject()
  add(query_598173, "upload_protocol", newJString(uploadProtocol))
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(path_598172, "name", newJString(name))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "callback", newJString(callback))
  add(query_598173, "access_token", newJString(accessToken))
  add(query_598173, "uploadType", newJString(uploadType))
  add(query_598173, "key", newJString(key))
  add(query_598173, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598174 = body
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  result = call_598171.call(path_598172, query_598173, nil, nil, body_598174)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598154(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:updatePrimaryVersion", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598155,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_598156,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598199 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598201(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598200(
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
  var valid_598202 = path.getOrDefault("parent")
  valid_598202 = validateParameter(valid_598202, JString, required = true,
                                 default = nil)
  if valid_598202 != nil:
    section.add "parent", valid_598202
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598203 = query.getOrDefault("upload_protocol")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "upload_protocol", valid_598203
  var valid_598204 = query.getOrDefault("fields")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "fields", valid_598204
  var valid_598205 = query.getOrDefault("quotaUser")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "quotaUser", valid_598205
  var valid_598206 = query.getOrDefault("alt")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = newJString("json"))
  if valid_598206 != nil:
    section.add "alt", valid_598206
  var valid_598207 = query.getOrDefault("oauth_token")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "oauth_token", valid_598207
  var valid_598208 = query.getOrDefault("callback")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "callback", valid_598208
  var valid_598209 = query.getOrDefault("access_token")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "access_token", valid_598209
  var valid_598210 = query.getOrDefault("uploadType")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "uploadType", valid_598210
  var valid_598211 = query.getOrDefault("key")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "key", valid_598211
  var valid_598212 = query.getOrDefault("$.xgafv")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = newJString("1"))
  if valid_598212 != nil:
    section.add "$.xgafv", valid_598212
  var valid_598213 = query.getOrDefault("prettyPrint")
  valid_598213 = validateParameter(valid_598213, JBool, required = false,
                                 default = newJBool(true))
  if valid_598213 != nil:
    section.add "prettyPrint", valid_598213
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

proc call*(call_598215: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  let valid = call_598215.validator(path, query, header, formData, body)
  let scheme = call_598215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598215.url(scheme.get, call_598215.host, call_598215.base,
                         call_598215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598215, url, valid)

proc call*(call_598216: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598199;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the CryptoKey associated with
  ## the CryptoKeyVersions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598217 = newJObject()
  var query_598218 = newJObject()
  var body_598219 = newJObject()
  add(query_598218, "upload_protocol", newJString(uploadProtocol))
  add(query_598218, "fields", newJString(fields))
  add(query_598218, "quotaUser", newJString(quotaUser))
  add(query_598218, "alt", newJString(alt))
  add(query_598218, "oauth_token", newJString(oauthToken))
  add(query_598218, "callback", newJString(callback))
  add(query_598218, "access_token", newJString(accessToken))
  add(query_598218, "uploadType", newJString(uploadType))
  add(path_598217, "parent", newJString(parent))
  add(query_598218, "key", newJString(key))
  add(query_598218, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598219 = body
  add(query_598218, "prettyPrint", newJBool(prettyPrint))
  result = call_598216.call(path_598217, query_598218, nil, nil, body_598219)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598199(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598200,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_598201,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598175 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598177(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598176(
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
  var valid_598178 = path.getOrDefault("parent")
  valid_598178 = validateParameter(valid_598178, JString, required = true,
                                 default = nil)
  if valid_598178 != nil:
    section.add "parent", valid_598178
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token, returned earlier via
  ## ListCryptoKeyVersionsResponse.next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : The fields to include in the response.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of CryptoKeyVersions to
  ## include in the response. Further CryptoKeyVersions can
  ## subsequently be obtained by including the
  ## ListCryptoKeyVersionsResponse.next_page_token in a subsequent request.
  ## If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  section = newJObject()
  var valid_598179 = query.getOrDefault("upload_protocol")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "upload_protocol", valid_598179
  var valid_598180 = query.getOrDefault("fields")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "fields", valid_598180
  var valid_598181 = query.getOrDefault("pageToken")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "pageToken", valid_598181
  var valid_598182 = query.getOrDefault("quotaUser")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "quotaUser", valid_598182
  var valid_598183 = query.getOrDefault("view")
  valid_598183 = validateParameter(valid_598183, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_598183 != nil:
    section.add "view", valid_598183
  var valid_598184 = query.getOrDefault("alt")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = newJString("json"))
  if valid_598184 != nil:
    section.add "alt", valid_598184
  var valid_598185 = query.getOrDefault("oauth_token")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "oauth_token", valid_598185
  var valid_598186 = query.getOrDefault("callback")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "callback", valid_598186
  var valid_598187 = query.getOrDefault("access_token")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "access_token", valid_598187
  var valid_598188 = query.getOrDefault("uploadType")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "uploadType", valid_598188
  var valid_598189 = query.getOrDefault("orderBy")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "orderBy", valid_598189
  var valid_598190 = query.getOrDefault("key")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "key", valid_598190
  var valid_598191 = query.getOrDefault("$.xgafv")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = newJString("1"))
  if valid_598191 != nil:
    section.add "$.xgafv", valid_598191
  var valid_598192 = query.getOrDefault("pageSize")
  valid_598192 = validateParameter(valid_598192, JInt, required = false, default = nil)
  if valid_598192 != nil:
    section.add "pageSize", valid_598192
  var valid_598193 = query.getOrDefault("prettyPrint")
  valid_598193 = validateParameter(valid_598193, JBool, required = false,
                                 default = newJBool(true))
  if valid_598193 != nil:
    section.add "prettyPrint", valid_598193
  var valid_598194 = query.getOrDefault("filter")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "filter", valid_598194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598195: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeyVersions.
  ## 
  let valid = call_598195.validator(path, query, header, formData, body)
  let scheme = call_598195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598195.url(scheme.get, call_598195.host, call_598195.base,
                         call_598195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598195, url, valid)

proc call*(call_598196: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598175;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; orderBy: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList
  ## Lists CryptoKeyVersions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token, returned earlier via
  ## ListCryptoKeyVersionsResponse.next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : The fields to include in the response.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the CryptoKey to list, in the format
  ## `projects/*/locations/*/keyRings/*/cryptoKeys/*`.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of CryptoKeyVersions to
  ## include in the response. Further CryptoKeyVersions can
  ## subsequently be obtained by including the
  ## ListCryptoKeyVersionsResponse.next_page_token in a subsequent request.
  ## If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  var path_598197 = newJObject()
  var query_598198 = newJObject()
  add(query_598198, "upload_protocol", newJString(uploadProtocol))
  add(query_598198, "fields", newJString(fields))
  add(query_598198, "pageToken", newJString(pageToken))
  add(query_598198, "quotaUser", newJString(quotaUser))
  add(query_598198, "view", newJString(view))
  add(query_598198, "alt", newJString(alt))
  add(query_598198, "oauth_token", newJString(oauthToken))
  add(query_598198, "callback", newJString(callback))
  add(query_598198, "access_token", newJString(accessToken))
  add(query_598198, "uploadType", newJString(uploadType))
  add(path_598197, "parent", newJString(parent))
  add(query_598198, "orderBy", newJString(orderBy))
  add(query_598198, "key", newJString(key))
  add(query_598198, "$.xgafv", newJString(Xgafv))
  add(query_598198, "pageSize", newJInt(pageSize))
  add(query_598198, "prettyPrint", newJBool(prettyPrint))
  add(query_598198, "filter", newJString(filter))
  result = call_598196.call(path_598197, query_598198, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598175(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598176,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_598177,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598220 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598222(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeyVersions:import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598221(
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
  var valid_598223 = path.getOrDefault("parent")
  valid_598223 = validateParameter(valid_598223, JString, required = true,
                                 default = nil)
  if valid_598223 != nil:
    section.add "parent", valid_598223
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598224 = query.getOrDefault("upload_protocol")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "upload_protocol", valid_598224
  var valid_598225 = query.getOrDefault("fields")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "fields", valid_598225
  var valid_598226 = query.getOrDefault("quotaUser")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "quotaUser", valid_598226
  var valid_598227 = query.getOrDefault("alt")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("json"))
  if valid_598227 != nil:
    section.add "alt", valid_598227
  var valid_598228 = query.getOrDefault("oauth_token")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "oauth_token", valid_598228
  var valid_598229 = query.getOrDefault("callback")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "callback", valid_598229
  var valid_598230 = query.getOrDefault("access_token")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "access_token", valid_598230
  var valid_598231 = query.getOrDefault("uploadType")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "uploadType", valid_598231
  var valid_598232 = query.getOrDefault("key")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "key", valid_598232
  var valid_598233 = query.getOrDefault("$.xgafv")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = newJString("1"))
  if valid_598233 != nil:
    section.add "$.xgafv", valid_598233
  var valid_598234 = query.getOrDefault("prettyPrint")
  valid_598234 = validateParameter(valid_598234, JBool, required = false,
                                 default = newJBool(true))
  if valid_598234 != nil:
    section.add "prettyPrint", valid_598234
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

proc call*(call_598236: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  let valid = call_598236.validator(path, query, header, formData, body)
  let scheme = call_598236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598236.url(scheme.get, call_598236.host, call_598236.base,
                         call_598236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598236, url, valid)

proc call*(call_598237: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598220;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the CryptoKey to
  ## be imported into.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598238 = newJObject()
  var query_598239 = newJObject()
  var body_598240 = newJObject()
  add(query_598239, "upload_protocol", newJString(uploadProtocol))
  add(query_598239, "fields", newJString(fields))
  add(query_598239, "quotaUser", newJString(quotaUser))
  add(query_598239, "alt", newJString(alt))
  add(query_598239, "oauth_token", newJString(oauthToken))
  add(query_598239, "callback", newJString(callback))
  add(query_598239, "access_token", newJString(accessToken))
  add(query_598239, "uploadType", newJString(uploadType))
  add(path_598238, "parent", newJString(parent))
  add(query_598239, "key", newJString(key))
  add(query_598239, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598240 = body
  add(query_598239, "prettyPrint", newJBool(prettyPrint))
  result = call_598237.call(path_598238, query_598239, nil, nil, body_598240)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598220(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions:import", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598221,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_598222,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598265 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598267(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598266(
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
  var valid_598268 = path.getOrDefault("parent")
  valid_598268 = validateParameter(valid_598268, JString, required = true,
                                 default = nil)
  if valid_598268 != nil:
    section.add "parent", valid_598268
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   cryptoKeyId: JString
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   skipInitialVersionCreation: JBool
  ##                             : If set to true, the request will create a CryptoKey without any
  ## CryptoKeyVersions. You must manually call
  ## CreateCryptoKeyVersion or
  ## ImportCryptoKeyVersion
  ## before you can use this CryptoKey.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598269 = query.getOrDefault("upload_protocol")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "upload_protocol", valid_598269
  var valid_598270 = query.getOrDefault("fields")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "fields", valid_598270
  var valid_598271 = query.getOrDefault("quotaUser")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "quotaUser", valid_598271
  var valid_598272 = query.getOrDefault("alt")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = newJString("json"))
  if valid_598272 != nil:
    section.add "alt", valid_598272
  var valid_598273 = query.getOrDefault("cryptoKeyId")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "cryptoKeyId", valid_598273
  var valid_598274 = query.getOrDefault("oauth_token")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "oauth_token", valid_598274
  var valid_598275 = query.getOrDefault("callback")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = nil)
  if valid_598275 != nil:
    section.add "callback", valid_598275
  var valid_598276 = query.getOrDefault("access_token")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = nil)
  if valid_598276 != nil:
    section.add "access_token", valid_598276
  var valid_598277 = query.getOrDefault("uploadType")
  valid_598277 = validateParameter(valid_598277, JString, required = false,
                                 default = nil)
  if valid_598277 != nil:
    section.add "uploadType", valid_598277
  var valid_598278 = query.getOrDefault("skipInitialVersionCreation")
  valid_598278 = validateParameter(valid_598278, JBool, required = false, default = nil)
  if valid_598278 != nil:
    section.add "skipInitialVersionCreation", valid_598278
  var valid_598279 = query.getOrDefault("key")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "key", valid_598279
  var valid_598280 = query.getOrDefault("$.xgafv")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = newJString("1"))
  if valid_598280 != nil:
    section.add "$.xgafv", valid_598280
  var valid_598281 = query.getOrDefault("prettyPrint")
  valid_598281 = validateParameter(valid_598281, JBool, required = false,
                                 default = newJBool(true))
  if valid_598281 != nil:
    section.add "prettyPrint", valid_598281
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

proc call*(call_598283: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  let valid = call_598283.validator(path, query, header, formData, body)
  let scheme = call_598283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598283.url(scheme.get, call_598283.host, call_598283.base,
                         call_598283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598283, url, valid)

proc call*(call_598284: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598265;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; cryptoKeyId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; skipInitialVersionCreation: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   cryptoKeyId: string
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the KeyRing associated with the
  ## CryptoKeys.
  ##   skipInitialVersionCreation: bool
  ##                             : If set to true, the request will create a CryptoKey without any
  ## CryptoKeyVersions. You must manually call
  ## CreateCryptoKeyVersion or
  ## ImportCryptoKeyVersion
  ## before you can use this CryptoKey.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598285 = newJObject()
  var query_598286 = newJObject()
  var body_598287 = newJObject()
  add(query_598286, "upload_protocol", newJString(uploadProtocol))
  add(query_598286, "fields", newJString(fields))
  add(query_598286, "quotaUser", newJString(quotaUser))
  add(query_598286, "alt", newJString(alt))
  add(query_598286, "cryptoKeyId", newJString(cryptoKeyId))
  add(query_598286, "oauth_token", newJString(oauthToken))
  add(query_598286, "callback", newJString(callback))
  add(query_598286, "access_token", newJString(accessToken))
  add(query_598286, "uploadType", newJString(uploadType))
  add(path_598285, "parent", newJString(parent))
  add(query_598286, "skipInitialVersionCreation",
      newJBool(skipInitialVersionCreation))
  add(query_598286, "key", newJString(key))
  add(query_598286, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598287 = body
  add(query_598286, "prettyPrint", newJBool(prettyPrint))
  result = call_598284.call(path_598285, query_598286, nil, nil, body_598287)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598265(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598266,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_598267,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598241 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/cryptoKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598242(
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
  var valid_598244 = path.getOrDefault("parent")
  valid_598244 = validateParameter(valid_598244, JString, required = true,
                                 default = nil)
  if valid_598244 != nil:
    section.add "parent", valid_598244
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token, returned earlier via
  ## ListCryptoKeysResponse.next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   versionView: JString
  ##              : The fields of the primary version to include in the response.
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of CryptoKeys to include in the
  ## response.  Further CryptoKeys can subsequently be obtained by
  ## including the ListCryptoKeysResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  section = newJObject()
  var valid_598245 = query.getOrDefault("upload_protocol")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "upload_protocol", valid_598245
  var valid_598246 = query.getOrDefault("fields")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "fields", valid_598246
  var valid_598247 = query.getOrDefault("pageToken")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "pageToken", valid_598247
  var valid_598248 = query.getOrDefault("quotaUser")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "quotaUser", valid_598248
  var valid_598249 = query.getOrDefault("alt")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = newJString("json"))
  if valid_598249 != nil:
    section.add "alt", valid_598249
  var valid_598250 = query.getOrDefault("oauth_token")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "oauth_token", valid_598250
  var valid_598251 = query.getOrDefault("callback")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "callback", valid_598251
  var valid_598252 = query.getOrDefault("access_token")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "access_token", valid_598252
  var valid_598253 = query.getOrDefault("uploadType")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "uploadType", valid_598253
  var valid_598254 = query.getOrDefault("versionView")
  valid_598254 = validateParameter(valid_598254, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_598254 != nil:
    section.add "versionView", valid_598254
  var valid_598255 = query.getOrDefault("orderBy")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "orderBy", valid_598255
  var valid_598256 = query.getOrDefault("key")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "key", valid_598256
  var valid_598257 = query.getOrDefault("$.xgafv")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = newJString("1"))
  if valid_598257 != nil:
    section.add "$.xgafv", valid_598257
  var valid_598258 = query.getOrDefault("pageSize")
  valid_598258 = validateParameter(valid_598258, JInt, required = false, default = nil)
  if valid_598258 != nil:
    section.add "pageSize", valid_598258
  var valid_598259 = query.getOrDefault("prettyPrint")
  valid_598259 = validateParameter(valid_598259, JBool, required = false,
                                 default = newJBool(true))
  if valid_598259 != nil:
    section.add "prettyPrint", valid_598259
  var valid_598260 = query.getOrDefault("filter")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "filter", valid_598260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598261: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeys.
  ## 
  let valid = call_598261.validator(path, query, header, formData, body)
  let scheme = call_598261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598261.url(scheme.get, call_598261.host, call_598261.base,
                         call_598261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598261, url, valid)

proc call*(call_598262: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598241;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          versionView: string = "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysList
  ## Lists CryptoKeys.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token, returned earlier via
  ## ListCryptoKeysResponse.next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  ##   versionView: string
  ##              : The fields of the primary version to include in the response.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of CryptoKeys to include in the
  ## response.  Further CryptoKeys can subsequently be obtained by
  ## including the ListCryptoKeysResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  var path_598263 = newJObject()
  var query_598264 = newJObject()
  add(query_598264, "upload_protocol", newJString(uploadProtocol))
  add(query_598264, "fields", newJString(fields))
  add(query_598264, "pageToken", newJString(pageToken))
  add(query_598264, "quotaUser", newJString(quotaUser))
  add(query_598264, "alt", newJString(alt))
  add(query_598264, "oauth_token", newJString(oauthToken))
  add(query_598264, "callback", newJString(callback))
  add(query_598264, "access_token", newJString(accessToken))
  add(query_598264, "uploadType", newJString(uploadType))
  add(path_598263, "parent", newJString(parent))
  add(query_598264, "versionView", newJString(versionView))
  add(query_598264, "orderBy", newJString(orderBy))
  add(query_598264, "key", newJString(key))
  add(query_598264, "$.xgafv", newJString(Xgafv))
  add(query_598264, "pageSize", newJInt(pageSize))
  add(query_598264, "prettyPrint", newJBool(prettyPrint))
  add(query_598264, "filter", newJString(filter))
  result = call_598262.call(path_598263, query_598264, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598241(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598242,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_598243,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598311 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598313(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/importJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598312(
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
  var valid_598314 = path.getOrDefault("parent")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "parent", valid_598314
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   importJobId: JString
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598315 = query.getOrDefault("upload_protocol")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "upload_protocol", valid_598315
  var valid_598316 = query.getOrDefault("fields")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "fields", valid_598316
  var valid_598317 = query.getOrDefault("quotaUser")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "quotaUser", valid_598317
  var valid_598318 = query.getOrDefault("alt")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = newJString("json"))
  if valid_598318 != nil:
    section.add "alt", valid_598318
  var valid_598319 = query.getOrDefault("importJobId")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "importJobId", valid_598319
  var valid_598320 = query.getOrDefault("oauth_token")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "oauth_token", valid_598320
  var valid_598321 = query.getOrDefault("callback")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "callback", valid_598321
  var valid_598322 = query.getOrDefault("access_token")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "access_token", valid_598322
  var valid_598323 = query.getOrDefault("uploadType")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "uploadType", valid_598323
  var valid_598324 = query.getOrDefault("key")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "key", valid_598324
  var valid_598325 = query.getOrDefault("$.xgafv")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = newJString("1"))
  if valid_598325 != nil:
    section.add "$.xgafv", valid_598325
  var valid_598326 = query.getOrDefault("prettyPrint")
  valid_598326 = validateParameter(valid_598326, JBool, required = false,
                                 default = newJBool(true))
  if valid_598326 != nil:
    section.add "prettyPrint", valid_598326
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

proc call*(call_598328: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  let valid = call_598328.validator(path, query, header, formData, body)
  let scheme = call_598328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598328.url(scheme.get, call_598328.host, call_598328.base,
                         call_598328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598328, url, valid)

proc call*(call_598329: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598311;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; importJobId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsCreate
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   importJobId: string
  ##              : Required. It must be unique within a KeyRing and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the KeyRing associated with the
  ## ImportJobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598330 = newJObject()
  var query_598331 = newJObject()
  var body_598332 = newJObject()
  add(query_598331, "upload_protocol", newJString(uploadProtocol))
  add(query_598331, "fields", newJString(fields))
  add(query_598331, "quotaUser", newJString(quotaUser))
  add(query_598331, "alt", newJString(alt))
  add(query_598331, "importJobId", newJString(importJobId))
  add(query_598331, "oauth_token", newJString(oauthToken))
  add(query_598331, "callback", newJString(callback))
  add(query_598331, "access_token", newJString(accessToken))
  add(query_598331, "uploadType", newJString(uploadType))
  add(path_598330, "parent", newJString(parent))
  add(query_598331, "key", newJString(key))
  add(query_598331, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598332 = body
  add(query_598331, "prettyPrint", newJBool(prettyPrint))
  result = call_598329.call(path_598330, query_598331, nil, nil, body_598332)

var cloudkmsProjectsLocationsKeyRingsImportJobsCreate* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598311(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598312,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_598313,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_598288 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsList_598290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/importJobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_598289(
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
  var valid_598291 = path.getOrDefault("parent")
  valid_598291 = validateParameter(valid_598291, JString, required = true,
                                 default = nil)
  if valid_598291 != nil:
    section.add "parent", valid_598291
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token, returned earlier via
  ## ListImportJobsResponse.next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of ImportJobs to include in the
  ## response. Further ImportJobs can subsequently be obtained by
  ## including the ListImportJobsResponse.next_page_token in a subsequent
  ## request. If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  section = newJObject()
  var valid_598292 = query.getOrDefault("upload_protocol")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "upload_protocol", valid_598292
  var valid_598293 = query.getOrDefault("fields")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "fields", valid_598293
  var valid_598294 = query.getOrDefault("pageToken")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "pageToken", valid_598294
  var valid_598295 = query.getOrDefault("quotaUser")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "quotaUser", valid_598295
  var valid_598296 = query.getOrDefault("alt")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("json"))
  if valid_598296 != nil:
    section.add "alt", valid_598296
  var valid_598297 = query.getOrDefault("oauth_token")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "oauth_token", valid_598297
  var valid_598298 = query.getOrDefault("callback")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "callback", valid_598298
  var valid_598299 = query.getOrDefault("access_token")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "access_token", valid_598299
  var valid_598300 = query.getOrDefault("uploadType")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "uploadType", valid_598300
  var valid_598301 = query.getOrDefault("orderBy")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "orderBy", valid_598301
  var valid_598302 = query.getOrDefault("key")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "key", valid_598302
  var valid_598303 = query.getOrDefault("$.xgafv")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = newJString("1"))
  if valid_598303 != nil:
    section.add "$.xgafv", valid_598303
  var valid_598304 = query.getOrDefault("pageSize")
  valid_598304 = validateParameter(valid_598304, JInt, required = false, default = nil)
  if valid_598304 != nil:
    section.add "pageSize", valid_598304
  var valid_598305 = query.getOrDefault("prettyPrint")
  valid_598305 = validateParameter(valid_598305, JBool, required = false,
                                 default = newJBool(true))
  if valid_598305 != nil:
    section.add "prettyPrint", valid_598305
  var valid_598306 = query.getOrDefault("filter")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "filter", valid_598306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598307: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_598288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ImportJobs.
  ## 
  let valid = call_598307.validator(path, query, header, formData, body)
  let scheme = call_598307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598307.url(scheme.get, call_598307.host, call_598307.base,
                         call_598307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598307, url, valid)

proc call*(call_598308: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_598288;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsList
  ## Lists ImportJobs.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token, returned earlier via
  ## ListImportJobsResponse.next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the KeyRing to list, in the format
  ## `projects/*/locations/*/keyRings/*`.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order. For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of ImportJobs to include in the
  ## response. Further ImportJobs can subsequently be obtained by
  ## including the ListImportJobsResponse.next_page_token in a subsequent
  ## request. If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  var path_598309 = newJObject()
  var query_598310 = newJObject()
  add(query_598310, "upload_protocol", newJString(uploadProtocol))
  add(query_598310, "fields", newJString(fields))
  add(query_598310, "pageToken", newJString(pageToken))
  add(query_598310, "quotaUser", newJString(quotaUser))
  add(query_598310, "alt", newJString(alt))
  add(query_598310, "oauth_token", newJString(oauthToken))
  add(query_598310, "callback", newJString(callback))
  add(query_598310, "access_token", newJString(accessToken))
  add(query_598310, "uploadType", newJString(uploadType))
  add(path_598309, "parent", newJString(parent))
  add(query_598310, "orderBy", newJString(orderBy))
  add(query_598310, "key", newJString(key))
  add(query_598310, "$.xgafv", newJString(Xgafv))
  add(query_598310, "pageSize", newJInt(pageSize))
  add(query_598310, "prettyPrint", newJBool(prettyPrint))
  add(query_598310, "filter", newJString(filter))
  result = call_598308.call(path_598309, query_598310, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsList* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_598288(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_598289,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsList_598290,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCreate_598356 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCreate_598358(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/keyRings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCreate_598357(path: JsonNode;
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
  var valid_598359 = path.getOrDefault("parent")
  valid_598359 = validateParameter(valid_598359, JString, required = true,
                                 default = nil)
  if valid_598359 != nil:
    section.add "parent", valid_598359
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   keyRingId: JString
  ##            : Required. It must be unique within a location and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  section = newJObject()
  var valid_598360 = query.getOrDefault("upload_protocol")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "upload_protocol", valid_598360
  var valid_598361 = query.getOrDefault("fields")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "fields", valid_598361
  var valid_598362 = query.getOrDefault("quotaUser")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "quotaUser", valid_598362
  var valid_598363 = query.getOrDefault("alt")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = newJString("json"))
  if valid_598363 != nil:
    section.add "alt", valid_598363
  var valid_598364 = query.getOrDefault("oauth_token")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "oauth_token", valid_598364
  var valid_598365 = query.getOrDefault("callback")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "callback", valid_598365
  var valid_598366 = query.getOrDefault("access_token")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = nil)
  if valid_598366 != nil:
    section.add "access_token", valid_598366
  var valid_598367 = query.getOrDefault("uploadType")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "uploadType", valid_598367
  var valid_598368 = query.getOrDefault("key")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "key", valid_598368
  var valid_598369 = query.getOrDefault("$.xgafv")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = newJString("1"))
  if valid_598369 != nil:
    section.add "$.xgafv", valid_598369
  var valid_598370 = query.getOrDefault("prettyPrint")
  valid_598370 = validateParameter(valid_598370, JBool, required = false,
                                 default = newJBool(true))
  if valid_598370 != nil:
    section.add "prettyPrint", valid_598370
  var valid_598371 = query.getOrDefault("keyRingId")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "keyRingId", valid_598371
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

proc call*(call_598373: Call_CloudkmsProjectsLocationsKeyRingsCreate_598356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  let valid = call_598373.validator(path, query, header, formData, body)
  let scheme = call_598373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598373.url(scheme.get, call_598373.host, call_598373.base,
                         call_598373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598373, url, valid)

proc call*(call_598374: Call_CloudkmsProjectsLocationsKeyRingsCreate_598356;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; keyRingId: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCreate
  ## Create a new KeyRing in a given Project and Location.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   keyRingId: string
  ##            : Required. It must be unique within a location and match the regular
  ## expression `[a-zA-Z0-9_-]{1,63}`
  var path_598375 = newJObject()
  var query_598376 = newJObject()
  var body_598377 = newJObject()
  add(query_598376, "upload_protocol", newJString(uploadProtocol))
  add(query_598376, "fields", newJString(fields))
  add(query_598376, "quotaUser", newJString(quotaUser))
  add(query_598376, "alt", newJString(alt))
  add(query_598376, "oauth_token", newJString(oauthToken))
  add(query_598376, "callback", newJString(callback))
  add(query_598376, "access_token", newJString(accessToken))
  add(query_598376, "uploadType", newJString(uploadType))
  add(path_598375, "parent", newJString(parent))
  add(query_598376, "key", newJString(key))
  add(query_598376, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598377 = body
  add(query_598376, "prettyPrint", newJBool(prettyPrint))
  add(query_598376, "keyRingId", newJString(keyRingId))
  result = call_598374.call(path_598375, query_598376, nil, nil, body_598377)

var cloudkmsProjectsLocationsKeyRingsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCreate_598356(
    name: "cloudkmsProjectsLocationsKeyRingsCreate", meth: HttpMethod.HttpPost,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCreate_598357, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCreate_598358,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsList_598333 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsList_598335(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/keyRings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsList_598334(path: JsonNode;
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
  var valid_598336 = path.getOrDefault("parent")
  valid_598336 = validateParameter(valid_598336, JString, required = true,
                                 default = nil)
  if valid_598336 != nil:
    section.add "parent", valid_598336
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token, returned earlier via
  ## ListKeyRingsResponse.next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order.  For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of KeyRings to include in the
  ## response.  Further KeyRings can subsequently be obtained by
  ## including the ListKeyRingsResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  section = newJObject()
  var valid_598337 = query.getOrDefault("upload_protocol")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "upload_protocol", valid_598337
  var valid_598338 = query.getOrDefault("fields")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "fields", valid_598338
  var valid_598339 = query.getOrDefault("pageToken")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "pageToken", valid_598339
  var valid_598340 = query.getOrDefault("quotaUser")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "quotaUser", valid_598340
  var valid_598341 = query.getOrDefault("alt")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = newJString("json"))
  if valid_598341 != nil:
    section.add "alt", valid_598341
  var valid_598342 = query.getOrDefault("oauth_token")
  valid_598342 = validateParameter(valid_598342, JString, required = false,
                                 default = nil)
  if valid_598342 != nil:
    section.add "oauth_token", valid_598342
  var valid_598343 = query.getOrDefault("callback")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "callback", valid_598343
  var valid_598344 = query.getOrDefault("access_token")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "access_token", valid_598344
  var valid_598345 = query.getOrDefault("uploadType")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "uploadType", valid_598345
  var valid_598346 = query.getOrDefault("orderBy")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "orderBy", valid_598346
  var valid_598347 = query.getOrDefault("key")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "key", valid_598347
  var valid_598348 = query.getOrDefault("$.xgafv")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = newJString("1"))
  if valid_598348 != nil:
    section.add "$.xgafv", valid_598348
  var valid_598349 = query.getOrDefault("pageSize")
  valid_598349 = validateParameter(valid_598349, JInt, required = false, default = nil)
  if valid_598349 != nil:
    section.add "pageSize", valid_598349
  var valid_598350 = query.getOrDefault("prettyPrint")
  valid_598350 = validateParameter(valid_598350, JBool, required = false,
                                 default = newJBool(true))
  if valid_598350 != nil:
    section.add "prettyPrint", valid_598350
  var valid_598351 = query.getOrDefault("filter")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "filter", valid_598351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598352: Call_CloudkmsProjectsLocationsKeyRingsList_598333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists KeyRings.
  ## 
  let valid = call_598352.validator(path, query, header, formData, body)
  let scheme = call_598352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598352.url(scheme.get, call_598352.host, call_598352.base,
                         call_598352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598352, url, valid)

proc call*(call_598353: Call_CloudkmsProjectsLocationsKeyRingsList_598333;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsList
  ## Lists KeyRings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token, returned earlier via
  ## ListKeyRingsResponse.next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name of the location associated with the
  ## KeyRings, in the format `projects/*/locations/*`.
  ##   orderBy: string
  ##          : Optional. Specify how the results should be sorted. If not specified, the
  ## results will be sorted in the default order.  For more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of KeyRings to include in the
  ## response.  Further KeyRings can subsequently be obtained by
  ## including the ListKeyRingsResponse.next_page_token in a subsequent
  ## request.  If unspecified, the server will pick an appropriate default.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Only include resources that match the filter in the response. For
  ## more information, see
  ## [Sorting and filtering list
  ## results](https://cloud.google.com/kms/docs/sorting-and-filtering).
  var path_598354 = newJObject()
  var query_598355 = newJObject()
  add(query_598355, "upload_protocol", newJString(uploadProtocol))
  add(query_598355, "fields", newJString(fields))
  add(query_598355, "pageToken", newJString(pageToken))
  add(query_598355, "quotaUser", newJString(quotaUser))
  add(query_598355, "alt", newJString(alt))
  add(query_598355, "oauth_token", newJString(oauthToken))
  add(query_598355, "callback", newJString(callback))
  add(query_598355, "access_token", newJString(accessToken))
  add(query_598355, "uploadType", newJString(uploadType))
  add(path_598354, "parent", newJString(parent))
  add(query_598355, "orderBy", newJString(orderBy))
  add(query_598355, "key", newJString(key))
  add(query_598355, "$.xgafv", newJString(Xgafv))
  add(query_598355, "pageSize", newJInt(pageSize))
  add(query_598355, "prettyPrint", newJBool(prettyPrint))
  add(query_598355, "filter", newJString(filter))
  result = call_598353.call(path_598354, query_598355, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsList* = Call_CloudkmsProjectsLocationsKeyRingsList_598333(
    name: "cloudkmsProjectsLocationsKeyRingsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsList_598334, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsList_598335, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598378 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598380(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598379(
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
  var valid_598381 = path.getOrDefault("resource")
  valid_598381 = validateParameter(valid_598381, JString, required = true,
                                 default = nil)
  if valid_598381 != nil:
    section.add "resource", valid_598381
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598382 = query.getOrDefault("upload_protocol")
  valid_598382 = validateParameter(valid_598382, JString, required = false,
                                 default = nil)
  if valid_598382 != nil:
    section.add "upload_protocol", valid_598382
  var valid_598383 = query.getOrDefault("fields")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "fields", valid_598383
  var valid_598384 = query.getOrDefault("quotaUser")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "quotaUser", valid_598384
  var valid_598385 = query.getOrDefault("alt")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = newJString("json"))
  if valid_598385 != nil:
    section.add "alt", valid_598385
  var valid_598386 = query.getOrDefault("oauth_token")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "oauth_token", valid_598386
  var valid_598387 = query.getOrDefault("callback")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "callback", valid_598387
  var valid_598388 = query.getOrDefault("access_token")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "access_token", valid_598388
  var valid_598389 = query.getOrDefault("uploadType")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "uploadType", valid_598389
  var valid_598390 = query.getOrDefault("options.requestedPolicyVersion")
  valid_598390 = validateParameter(valid_598390, JInt, required = false, default = nil)
  if valid_598390 != nil:
    section.add "options.requestedPolicyVersion", valid_598390
  var valid_598391 = query.getOrDefault("key")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "key", valid_598391
  var valid_598392 = query.getOrDefault("$.xgafv")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = newJString("1"))
  if valid_598392 != nil:
    section.add "$.xgafv", valid_598392
  var valid_598393 = query.getOrDefault("prettyPrint")
  valid_598393 = validateParameter(valid_598393, JBool, required = false,
                                 default = newJBool(true))
  if valid_598393 != nil:
    section.add "prettyPrint", valid_598393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598394: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_598394.validator(path, query, header, formData, body)
  let scheme = call_598394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598394.url(scheme.get, call_598394.host, call_598394.base,
                         call_598394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598394, url, valid)

proc call*(call_598395: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598378;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## Acceptable values are 0, 1, and 3.
  ## If the value is 0, or the field is omitted, policy format version 1 will be
  ## returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598396 = newJObject()
  var query_598397 = newJObject()
  add(query_598397, "upload_protocol", newJString(uploadProtocol))
  add(query_598397, "fields", newJString(fields))
  add(query_598397, "quotaUser", newJString(quotaUser))
  add(query_598397, "alt", newJString(alt))
  add(query_598397, "oauth_token", newJString(oauthToken))
  add(query_598397, "callback", newJString(callback))
  add(query_598397, "access_token", newJString(accessToken))
  add(query_598397, "uploadType", newJString(uploadType))
  add(query_598397, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_598397, "key", newJString(key))
  add(query_598397, "$.xgafv", newJString(Xgafv))
  add(path_598396, "resource", newJString(resource))
  add(query_598397, "prettyPrint", newJBool(prettyPrint))
  result = call_598395.call(path_598396, query_598397, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598378(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:getIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598379,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_598380,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598398 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598400(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598399(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_598401 = path.getOrDefault("resource")
  valid_598401 = validateParameter(valid_598401, JString, required = true,
                                 default = nil)
  if valid_598401 != nil:
    section.add "resource", valid_598401
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598402 = query.getOrDefault("upload_protocol")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "upload_protocol", valid_598402
  var valid_598403 = query.getOrDefault("fields")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = nil)
  if valid_598403 != nil:
    section.add "fields", valid_598403
  var valid_598404 = query.getOrDefault("quotaUser")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "quotaUser", valid_598404
  var valid_598405 = query.getOrDefault("alt")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = newJString("json"))
  if valid_598405 != nil:
    section.add "alt", valid_598405
  var valid_598406 = query.getOrDefault("oauth_token")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "oauth_token", valid_598406
  var valid_598407 = query.getOrDefault("callback")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "callback", valid_598407
  var valid_598408 = query.getOrDefault("access_token")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "access_token", valid_598408
  var valid_598409 = query.getOrDefault("uploadType")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "uploadType", valid_598409
  var valid_598410 = query.getOrDefault("key")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "key", valid_598410
  var valid_598411 = query.getOrDefault("$.xgafv")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = newJString("1"))
  if valid_598411 != nil:
    section.add "$.xgafv", valid_598411
  var valid_598412 = query.getOrDefault("prettyPrint")
  valid_598412 = validateParameter(valid_598412, JBool, required = false,
                                 default = newJBool(true))
  if valid_598412 != nil:
    section.add "prettyPrint", valid_598412
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

proc call*(call_598414: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_598414.validator(path, query, header, formData, body)
  let scheme = call_598414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598414.url(scheme.get, call_598414.host, call_598414.base,
                         call_598414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598414, url, valid)

proc call*(call_598415: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598398;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598416 = newJObject()
  var query_598417 = newJObject()
  var body_598418 = newJObject()
  add(query_598417, "upload_protocol", newJString(uploadProtocol))
  add(query_598417, "fields", newJString(fields))
  add(query_598417, "quotaUser", newJString(quotaUser))
  add(query_598417, "alt", newJString(alt))
  add(query_598417, "oauth_token", newJString(oauthToken))
  add(query_598417, "callback", newJString(callback))
  add(query_598417, "access_token", newJString(accessToken))
  add(query_598417, "uploadType", newJString(uploadType))
  add(query_598417, "key", newJString(key))
  add(query_598417, "$.xgafv", newJString(Xgafv))
  add(path_598416, "resource", newJString(resource))
  if body != nil:
    body_598418 = body
  add(query_598417, "prettyPrint", newJBool(prettyPrint))
  result = call_598415.call(path_598416, query_598417, nil, nil, body_598418)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598398(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:setIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598399,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_598400,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598419 = ref object of OpenApiRestCall_597408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598421(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598420(
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
  var valid_598422 = path.getOrDefault("resource")
  valid_598422 = validateParameter(valid_598422, JString, required = true,
                                 default = nil)
  if valid_598422 != nil:
    section.add "resource", valid_598422
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598423 = query.getOrDefault("upload_protocol")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "upload_protocol", valid_598423
  var valid_598424 = query.getOrDefault("fields")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = nil)
  if valid_598424 != nil:
    section.add "fields", valid_598424
  var valid_598425 = query.getOrDefault("quotaUser")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "quotaUser", valid_598425
  var valid_598426 = query.getOrDefault("alt")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = newJString("json"))
  if valid_598426 != nil:
    section.add "alt", valid_598426
  var valid_598427 = query.getOrDefault("oauth_token")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "oauth_token", valid_598427
  var valid_598428 = query.getOrDefault("callback")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "callback", valid_598428
  var valid_598429 = query.getOrDefault("access_token")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "access_token", valid_598429
  var valid_598430 = query.getOrDefault("uploadType")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "uploadType", valid_598430
  var valid_598431 = query.getOrDefault("key")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "key", valid_598431
  var valid_598432 = query.getOrDefault("$.xgafv")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = newJString("1"))
  if valid_598432 != nil:
    section.add "$.xgafv", valid_598432
  var valid_598433 = query.getOrDefault("prettyPrint")
  valid_598433 = validateParameter(valid_598433, JBool, required = false,
                                 default = newJBool(true))
  if valid_598433 != nil:
    section.add "prettyPrint", valid_598433
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

proc call*(call_598435: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598419;
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
  let valid = call_598435.validator(path, query, header, formData, body)
  let scheme = call_598435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598435.url(scheme.get, call_598435.host, call_598435.base,
                         call_598435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598435, url, valid)

proc call*(call_598436: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598419;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598437 = newJObject()
  var query_598438 = newJObject()
  var body_598439 = newJObject()
  add(query_598438, "upload_protocol", newJString(uploadProtocol))
  add(query_598438, "fields", newJString(fields))
  add(query_598438, "quotaUser", newJString(quotaUser))
  add(query_598438, "alt", newJString(alt))
  add(query_598438, "oauth_token", newJString(oauthToken))
  add(query_598438, "callback", newJString(callback))
  add(query_598438, "access_token", newJString(accessToken))
  add(query_598438, "uploadType", newJString(uploadType))
  add(query_598438, "key", newJString(key))
  add(query_598438, "$.xgafv", newJString(Xgafv))
  add(path_598437, "resource", newJString(resource))
  if body != nil:
    body_598439 = body
  add(query_598438, "prettyPrint", newJBool(prettyPrint))
  result = call_598436.call(path_598437, query_598438, nil, nil, body_598439)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598419(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598420,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_598421,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
