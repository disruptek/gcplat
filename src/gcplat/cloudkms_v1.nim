
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579677 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579679(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579678(
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
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns metadata for a given CryptoKeyVersion.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579677;
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579677(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com", route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579678,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGet_579679,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579965 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579967(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579966(
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
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  var valid_579980 = query.getOrDefault("updateMask")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "updateMask", valid_579980
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

proc call*(call_579982: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579965;
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
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579965;
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
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(path_579984, "name", newJString(name))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579986 = body
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "updateMask", newJString(updateMask))
  result = call_579983.call(path_579984, query_579985, nil, nil, body_579986)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579965(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudkms.googleapis.com",
    route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579966,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_579967,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsList_579987 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsList_579989(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsList_579988(path: JsonNode; query: JsonNode;
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
  var valid_579990 = path.getOrDefault("name")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "name", valid_579990
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
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("pageToken")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "pageToken", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("oauth_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "oauth_token", valid_579996
  var valid_579997 = query.getOrDefault("callback")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "callback", valid_579997
  var valid_579998 = query.getOrDefault("access_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "access_token", valid_579998
  var valid_579999 = query.getOrDefault("uploadType")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "uploadType", valid_579999
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("pageSize")
  valid_580002 = validateParameter(valid_580002, JInt, required = false, default = nil)
  if valid_580002 != nil:
    section.add "pageSize", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  var valid_580004 = query.getOrDefault("filter")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "filter", valid_580004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580005: Call_CloudkmsProjectsLocationsList_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_CloudkmsProjectsLocationsList_579987; name: string;
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
  var path_580007 = newJObject()
  var query_580008 = newJObject()
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "pageToken", newJString(pageToken))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(path_580007, "name", newJString(name))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "uploadType", newJString(uploadType))
  add(query_580008, "key", newJString(key))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  add(query_580008, "pageSize", newJInt(pageSize))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  add(query_580008, "filter", newJString(filter))
  result = call_580006.call(path_580007, query_580008, nil, nil, nil)

var cloudkmsProjectsLocationsList* = Call_CloudkmsProjectsLocationsList_579987(
    name: "cloudkmsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudkmsProjectsLocationsList_579988, base: "/",
    url: url_CloudkmsProjectsLocationsList_579989, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580009 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580011(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580010(
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
  var valid_580012 = path.getOrDefault("name")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "name", valid_580012
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
  var valid_580013 = query.getOrDefault("upload_protocol")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "upload_protocol", valid_580013
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580009;
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(path_580026, "name", newJString(name))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580009(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{name}/publicKey", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580010,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_580011,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580028 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580030(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580029(
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
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("uploadType")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "uploadType", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
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

proc call*(call_580044: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580028;
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "key", newJString(key))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580048 = body
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580028(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricDecrypt", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580029,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_580030,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580049 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580051(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580050(
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
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
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
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
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

proc call*(call_580065: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580049;
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "key", newJString(key))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580069 = body
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580049(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricSign", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580050,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_580051,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580070 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580072(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580071(
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
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
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
  var valid_580074 = query.getOrDefault("upload_protocol")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "upload_protocol", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
  var valid_580082 = query.getOrDefault("key")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "key", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
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

proc call*(call_580086: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  let valid = call_580086.validator(path, query, header, formData, body)
  let scheme = call_580086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580086.url(scheme.get, call_580086.host, call_580086.base,
                         call_580086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580086, url, valid)

proc call*(call_580087: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580070;
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
  var path_580088 = newJObject()
  var query_580089 = newJObject()
  var body_580090 = newJObject()
  add(query_580089, "upload_protocol", newJString(uploadProtocol))
  add(query_580089, "fields", newJString(fields))
  add(query_580089, "quotaUser", newJString(quotaUser))
  add(path_580088, "name", newJString(name))
  add(query_580089, "alt", newJString(alt))
  add(query_580089, "oauth_token", newJString(oauthToken))
  add(query_580089, "callback", newJString(callback))
  add(query_580089, "access_token", newJString(accessToken))
  add(query_580089, "uploadType", newJString(uploadType))
  add(query_580089, "key", newJString(key))
  add(query_580089, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580090 = body
  add(query_580089, "prettyPrint", newJBool(prettyPrint))
  result = call_580087.call(path_580088, query_580089, nil, nil, body_580090)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580070(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:decrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580071,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_580072,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580091 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580093(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580092(
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
  var valid_580094 = path.getOrDefault("name")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "name", valid_580094
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
  var valid_580095 = query.getOrDefault("upload_protocol")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "upload_protocol", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("quotaUser")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "quotaUser", valid_580097
  var valid_580098 = query.getOrDefault("alt")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = newJString("json"))
  if valid_580098 != nil:
    section.add "alt", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("callback")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "callback", valid_580100
  var valid_580101 = query.getOrDefault("access_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "access_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("$.xgafv")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("1"))
  if valid_580104 != nil:
    section.add "$.xgafv", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
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

proc call*(call_580107: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580091;
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
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580091;
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
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  var body_580111 = newJObject()
  add(query_580110, "upload_protocol", newJString(uploadProtocol))
  add(query_580110, "fields", newJString(fields))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(path_580109, "name", newJString(name))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "callback", newJString(callback))
  add(query_580110, "access_token", newJString(accessToken))
  add(query_580110, "uploadType", newJString(uploadType))
  add(query_580110, "key", newJString(key))
  add(query_580110, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580111 = body
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  result = call_580108.call(path_580109, query_580110, nil, nil, body_580111)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580091(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:destroy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580092,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_580093,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580112 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580114(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580113(
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
  var valid_580115 = path.getOrDefault("name")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "name", valid_580115
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
  var valid_580116 = query.getOrDefault("upload_protocol")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "upload_protocol", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("alt")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("json"))
  if valid_580119 != nil:
    section.add "alt", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("callback")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "callback", valid_580121
  var valid_580122 = query.getOrDefault("access_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "access_token", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("$.xgafv")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("1"))
  if valid_580125 != nil:
    section.add "$.xgafv", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
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

proc call*(call_580128: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580112;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580112;
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
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  var body_580132 = newJObject()
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(path_580130, "name", newJString(name))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "uploadType", newJString(uploadType))
  add(query_580131, "key", newJString(key))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580132 = body
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(path_580130, query_580131, nil, nil, body_580132)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580112(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:encrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580113,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_580114,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580133 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580135(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580134(
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
  var valid_580136 = path.getOrDefault("name")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "name", valid_580136
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
  var valid_580137 = query.getOrDefault("upload_protocol")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "upload_protocol", valid_580137
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("access_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "access_token", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("$.xgafv")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("1"))
  if valid_580146 != nil:
    section.add "$.xgafv", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
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

proc call*(call_580149: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580133;
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
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580133;
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  var body_580153 = newJObject()
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(path_580151, "name", newJString(name))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "callback", newJString(callback))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "uploadType", newJString(uploadType))
  add(query_580152, "key", newJString(key))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580153 = body
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, body_580153)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580133(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:restore", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580134,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_580135,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580154 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580156(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580155(
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
  var valid_580157 = path.getOrDefault("name")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "name", valid_580157
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
  var valid_580158 = query.getOrDefault("upload_protocol")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "upload_protocol", valid_580158
  var valid_580159 = query.getOrDefault("fields")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "fields", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("alt")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("json"))
  if valid_580161 != nil:
    section.add "alt", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("callback")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "callback", valid_580163
  var valid_580164 = query.getOrDefault("access_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "access_token", valid_580164
  var valid_580165 = query.getOrDefault("uploadType")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "uploadType", valid_580165
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("$.xgafv")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("1"))
  if valid_580167 != nil:
    section.add "$.xgafv", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
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

proc call*(call_580170: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580154;
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
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(path_580172, "name", newJString(name))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "key", newJString(key))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580174 = body
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580154(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:updatePrimaryVersion", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580155,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_580156,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580199 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580201(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580200(
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
  var valid_580202 = path.getOrDefault("parent")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "parent", valid_580202
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
  var valid_580203 = query.getOrDefault("upload_protocol")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "upload_protocol", valid_580203
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("callback")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "callback", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("uploadType")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "uploadType", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("$.xgafv")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("1"))
  if valid_580212 != nil:
    section.add "$.xgafv", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
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

proc call*(call_580215: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580199;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580199;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  var body_580219 = newJObject()
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "callback", newJString(callback))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "uploadType", newJString(uploadType))
  add(path_580217, "parent", newJString(parent))
  add(query_580218, "key", newJString(key))
  add(query_580218, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580219 = body
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580199(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580200,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_580201,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580175 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580177(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580176(
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
  var valid_580178 = path.getOrDefault("parent")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "parent", valid_580178
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
  var valid_580179 = query.getOrDefault("upload_protocol")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "upload_protocol", valid_580179
  var valid_580180 = query.getOrDefault("fields")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "fields", valid_580180
  var valid_580181 = query.getOrDefault("pageToken")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "pageToken", valid_580181
  var valid_580182 = query.getOrDefault("quotaUser")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "quotaUser", valid_580182
  var valid_580183 = query.getOrDefault("view")
  valid_580183 = validateParameter(valid_580183, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_580183 != nil:
    section.add "view", valid_580183
  var valid_580184 = query.getOrDefault("alt")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("json"))
  if valid_580184 != nil:
    section.add "alt", valid_580184
  var valid_580185 = query.getOrDefault("oauth_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "oauth_token", valid_580185
  var valid_580186 = query.getOrDefault("callback")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "callback", valid_580186
  var valid_580187 = query.getOrDefault("access_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "access_token", valid_580187
  var valid_580188 = query.getOrDefault("uploadType")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "uploadType", valid_580188
  var valid_580189 = query.getOrDefault("orderBy")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "orderBy", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("$.xgafv")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("1"))
  if valid_580191 != nil:
    section.add "$.xgafv", valid_580191
  var valid_580192 = query.getOrDefault("pageSize")
  valid_580192 = validateParameter(valid_580192, JInt, required = false, default = nil)
  if valid_580192 != nil:
    section.add "pageSize", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
  var valid_580194 = query.getOrDefault("filter")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "filter", valid_580194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeyVersions.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580175;
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
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "pageToken", newJString(pageToken))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "view", newJString(view))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "callback", newJString(callback))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "uploadType", newJString(uploadType))
  add(path_580197, "parent", newJString(parent))
  add(query_580198, "orderBy", newJString(orderBy))
  add(query_580198, "key", newJString(key))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  add(query_580198, "pageSize", newJInt(pageSize))
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  add(query_580198, "filter", newJString(filter))
  result = call_580196.call(path_580197, query_580198, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580175(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580176,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_580177,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580220 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580222(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580221(
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
  var valid_580223 = path.getOrDefault("parent")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "parent", valid_580223
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
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("callback")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "callback", valid_580229
  var valid_580230 = query.getOrDefault("access_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "access_token", valid_580230
  var valid_580231 = query.getOrDefault("uploadType")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "uploadType", valid_580231
  var valid_580232 = query.getOrDefault("key")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "key", valid_580232
  var valid_580233 = query.getOrDefault("$.xgafv")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("1"))
  if valid_580233 != nil:
    section.add "$.xgafv", valid_580233
  var valid_580234 = query.getOrDefault("prettyPrint")
  valid_580234 = validateParameter(valid_580234, JBool, required = false,
                                 default = newJBool(true))
  if valid_580234 != nil:
    section.add "prettyPrint", valid_580234
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

proc call*(call_580236: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  let valid = call_580236.validator(path, query, header, formData, body)
  let scheme = call_580236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580236.url(scheme.get, call_580236.host, call_580236.base,
                         call_580236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580236, url, valid)

proc call*(call_580237: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580220;
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
  var path_580238 = newJObject()
  var query_580239 = newJObject()
  var body_580240 = newJObject()
  add(query_580239, "upload_protocol", newJString(uploadProtocol))
  add(query_580239, "fields", newJString(fields))
  add(query_580239, "quotaUser", newJString(quotaUser))
  add(query_580239, "alt", newJString(alt))
  add(query_580239, "oauth_token", newJString(oauthToken))
  add(query_580239, "callback", newJString(callback))
  add(query_580239, "access_token", newJString(accessToken))
  add(query_580239, "uploadType", newJString(uploadType))
  add(path_580238, "parent", newJString(parent))
  add(query_580239, "key", newJString(key))
  add(query_580239, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580240 = body
  add(query_580239, "prettyPrint", newJBool(prettyPrint))
  result = call_580237.call(path_580238, query_580239, nil, nil, body_580240)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580220(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions:import", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580221,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_580222,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580265 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580267(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580266(
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
  var valid_580268 = path.getOrDefault("parent")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "parent", valid_580268
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
  var valid_580269 = query.getOrDefault("upload_protocol")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "upload_protocol", valid_580269
  var valid_580270 = query.getOrDefault("fields")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "fields", valid_580270
  var valid_580271 = query.getOrDefault("quotaUser")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "quotaUser", valid_580271
  var valid_580272 = query.getOrDefault("alt")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("json"))
  if valid_580272 != nil:
    section.add "alt", valid_580272
  var valid_580273 = query.getOrDefault("cryptoKeyId")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "cryptoKeyId", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("callback")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "callback", valid_580275
  var valid_580276 = query.getOrDefault("access_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "access_token", valid_580276
  var valid_580277 = query.getOrDefault("uploadType")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "uploadType", valid_580277
  var valid_580278 = query.getOrDefault("skipInitialVersionCreation")
  valid_580278 = validateParameter(valid_580278, JBool, required = false, default = nil)
  if valid_580278 != nil:
    section.add "skipInitialVersionCreation", valid_580278
  var valid_580279 = query.getOrDefault("key")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "key", valid_580279
  var valid_580280 = query.getOrDefault("$.xgafv")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("1"))
  if valid_580280 != nil:
    section.add "$.xgafv", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
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

proc call*(call_580283: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  let valid = call_580283.validator(path, query, header, formData, body)
  let scheme = call_580283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580283.url(scheme.get, call_580283.host, call_580283.base,
                         call_580283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580283, url, valid)

proc call*(call_580284: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580265;
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
  var path_580285 = newJObject()
  var query_580286 = newJObject()
  var body_580287 = newJObject()
  add(query_580286, "upload_protocol", newJString(uploadProtocol))
  add(query_580286, "fields", newJString(fields))
  add(query_580286, "quotaUser", newJString(quotaUser))
  add(query_580286, "alt", newJString(alt))
  add(query_580286, "cryptoKeyId", newJString(cryptoKeyId))
  add(query_580286, "oauth_token", newJString(oauthToken))
  add(query_580286, "callback", newJString(callback))
  add(query_580286, "access_token", newJString(accessToken))
  add(query_580286, "uploadType", newJString(uploadType))
  add(path_580285, "parent", newJString(parent))
  add(query_580286, "skipInitialVersionCreation",
      newJBool(skipInitialVersionCreation))
  add(query_580286, "key", newJString(key))
  add(query_580286, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580287 = body
  add(query_580286, "prettyPrint", newJBool(prettyPrint))
  result = call_580284.call(path_580285, query_580286, nil, nil, body_580287)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580265(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580266,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_580267,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580241 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580243(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580242(
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
  var valid_580244 = path.getOrDefault("parent")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "parent", valid_580244
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
  var valid_580245 = query.getOrDefault("upload_protocol")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "upload_protocol", valid_580245
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("pageToken")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "pageToken", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("oauth_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "oauth_token", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("access_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "access_token", valid_580252
  var valid_580253 = query.getOrDefault("uploadType")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "uploadType", valid_580253
  var valid_580254 = query.getOrDefault("versionView")
  valid_580254 = validateParameter(valid_580254, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_580254 != nil:
    section.add "versionView", valid_580254
  var valid_580255 = query.getOrDefault("orderBy")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "orderBy", valid_580255
  var valid_580256 = query.getOrDefault("key")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "key", valid_580256
  var valid_580257 = query.getOrDefault("$.xgafv")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("1"))
  if valid_580257 != nil:
    section.add "$.xgafv", valid_580257
  var valid_580258 = query.getOrDefault("pageSize")
  valid_580258 = validateParameter(valid_580258, JInt, required = false, default = nil)
  if valid_580258 != nil:
    section.add "pageSize", valid_580258
  var valid_580259 = query.getOrDefault("prettyPrint")
  valid_580259 = validateParameter(valid_580259, JBool, required = false,
                                 default = newJBool(true))
  if valid_580259 != nil:
    section.add "prettyPrint", valid_580259
  var valid_580260 = query.getOrDefault("filter")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "filter", valid_580260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580261: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeys.
  ## 
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580241;
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
  var path_580263 = newJObject()
  var query_580264 = newJObject()
  add(query_580264, "upload_protocol", newJString(uploadProtocol))
  add(query_580264, "fields", newJString(fields))
  add(query_580264, "pageToken", newJString(pageToken))
  add(query_580264, "quotaUser", newJString(quotaUser))
  add(query_580264, "alt", newJString(alt))
  add(query_580264, "oauth_token", newJString(oauthToken))
  add(query_580264, "callback", newJString(callback))
  add(query_580264, "access_token", newJString(accessToken))
  add(query_580264, "uploadType", newJString(uploadType))
  add(path_580263, "parent", newJString(parent))
  add(query_580264, "versionView", newJString(versionView))
  add(query_580264, "orderBy", newJString(orderBy))
  add(query_580264, "key", newJString(key))
  add(query_580264, "$.xgafv", newJString(Xgafv))
  add(query_580264, "pageSize", newJInt(pageSize))
  add(query_580264, "prettyPrint", newJBool(prettyPrint))
  add(query_580264, "filter", newJString(filter))
  result = call_580262.call(path_580263, query_580264, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580241(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580242,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_580243,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580311 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580313(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580312(
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
  var valid_580314 = path.getOrDefault("parent")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "parent", valid_580314
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
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("quotaUser")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "quotaUser", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("importJobId")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "importJobId", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("callback")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "callback", valid_580321
  var valid_580322 = query.getOrDefault("access_token")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "access_token", valid_580322
  var valid_580323 = query.getOrDefault("uploadType")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "uploadType", valid_580323
  var valid_580324 = query.getOrDefault("key")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "key", valid_580324
  var valid_580325 = query.getOrDefault("$.xgafv")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("1"))
  if valid_580325 != nil:
    section.add "$.xgafv", valid_580325
  var valid_580326 = query.getOrDefault("prettyPrint")
  valid_580326 = validateParameter(valid_580326, JBool, required = false,
                                 default = newJBool(true))
  if valid_580326 != nil:
    section.add "prettyPrint", valid_580326
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

proc call*(call_580328: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580311;
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
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  var body_580332 = newJObject()
  add(query_580331, "upload_protocol", newJString(uploadProtocol))
  add(query_580331, "fields", newJString(fields))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "importJobId", newJString(importJobId))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(query_580331, "callback", newJString(callback))
  add(query_580331, "access_token", newJString(accessToken))
  add(query_580331, "uploadType", newJString(uploadType))
  add(path_580330, "parent", newJString(parent))
  add(query_580331, "key", newJString(key))
  add(query_580331, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580332 = body
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  result = call_580329.call(path_580330, query_580331, nil, nil, body_580332)

var cloudkmsProjectsLocationsKeyRingsImportJobsCreate* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580311(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580312,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_580313,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580288 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsList_580290(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_580289(
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
  var valid_580291 = path.getOrDefault("parent")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "parent", valid_580291
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
  var valid_580292 = query.getOrDefault("upload_protocol")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "upload_protocol", valid_580292
  var valid_580293 = query.getOrDefault("fields")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "fields", valid_580293
  var valid_580294 = query.getOrDefault("pageToken")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "pageToken", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("callback")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "callback", valid_580298
  var valid_580299 = query.getOrDefault("access_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "access_token", valid_580299
  var valid_580300 = query.getOrDefault("uploadType")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "uploadType", valid_580300
  var valid_580301 = query.getOrDefault("orderBy")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "orderBy", valid_580301
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("$.xgafv")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("1"))
  if valid_580303 != nil:
    section.add "$.xgafv", valid_580303
  var valid_580304 = query.getOrDefault("pageSize")
  valid_580304 = validateParameter(valid_580304, JInt, required = false, default = nil)
  if valid_580304 != nil:
    section.add "pageSize", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  var valid_580306 = query.getOrDefault("filter")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "filter", valid_580306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580307: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ImportJobs.
  ## 
  let valid = call_580307.validator(path, query, header, formData, body)
  let scheme = call_580307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580307.url(scheme.get, call_580307.host, call_580307.base,
                         call_580307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580307, url, valid)

proc call*(call_580308: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580288;
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
  var path_580309 = newJObject()
  var query_580310 = newJObject()
  add(query_580310, "upload_protocol", newJString(uploadProtocol))
  add(query_580310, "fields", newJString(fields))
  add(query_580310, "pageToken", newJString(pageToken))
  add(query_580310, "quotaUser", newJString(quotaUser))
  add(query_580310, "alt", newJString(alt))
  add(query_580310, "oauth_token", newJString(oauthToken))
  add(query_580310, "callback", newJString(callback))
  add(query_580310, "access_token", newJString(accessToken))
  add(query_580310, "uploadType", newJString(uploadType))
  add(path_580309, "parent", newJString(parent))
  add(query_580310, "orderBy", newJString(orderBy))
  add(query_580310, "key", newJString(key))
  add(query_580310, "$.xgafv", newJString(Xgafv))
  add(query_580310, "pageSize", newJInt(pageSize))
  add(query_580310, "prettyPrint", newJBool(prettyPrint))
  add(query_580310, "filter", newJString(filter))
  result = call_580308.call(path_580309, query_580310, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsList* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_580288(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_580289,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsList_580290,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCreate_580356 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCreate_580358(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCreate_580357(path: JsonNode;
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
  var valid_580359 = path.getOrDefault("parent")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "parent", valid_580359
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
  var valid_580360 = query.getOrDefault("upload_protocol")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "upload_protocol", valid_580360
  var valid_580361 = query.getOrDefault("fields")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fields", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("callback")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "callback", valid_580365
  var valid_580366 = query.getOrDefault("access_token")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "access_token", valid_580366
  var valid_580367 = query.getOrDefault("uploadType")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "uploadType", valid_580367
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("$.xgafv")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("1"))
  if valid_580369 != nil:
    section.add "$.xgafv", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
  var valid_580371 = query.getOrDefault("keyRingId")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "keyRingId", valid_580371
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

proc call*(call_580373: Call_CloudkmsProjectsLocationsKeyRingsCreate_580356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  let valid = call_580373.validator(path, query, header, formData, body)
  let scheme = call_580373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580373.url(scheme.get, call_580373.host, call_580373.base,
                         call_580373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580373, url, valid)

proc call*(call_580374: Call_CloudkmsProjectsLocationsKeyRingsCreate_580356;
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
  var path_580375 = newJObject()
  var query_580376 = newJObject()
  var body_580377 = newJObject()
  add(query_580376, "upload_protocol", newJString(uploadProtocol))
  add(query_580376, "fields", newJString(fields))
  add(query_580376, "quotaUser", newJString(quotaUser))
  add(query_580376, "alt", newJString(alt))
  add(query_580376, "oauth_token", newJString(oauthToken))
  add(query_580376, "callback", newJString(callback))
  add(query_580376, "access_token", newJString(accessToken))
  add(query_580376, "uploadType", newJString(uploadType))
  add(path_580375, "parent", newJString(parent))
  add(query_580376, "key", newJString(key))
  add(query_580376, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580377 = body
  add(query_580376, "prettyPrint", newJBool(prettyPrint))
  add(query_580376, "keyRingId", newJString(keyRingId))
  result = call_580374.call(path_580375, query_580376, nil, nil, body_580377)

var cloudkmsProjectsLocationsKeyRingsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCreate_580356(
    name: "cloudkmsProjectsLocationsKeyRingsCreate", meth: HttpMethod.HttpPost,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCreate_580357, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCreate_580358,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsList_580333 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsList_580335(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsList_580334(path: JsonNode;
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
  var valid_580336 = path.getOrDefault("parent")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "parent", valid_580336
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
  var valid_580337 = query.getOrDefault("upload_protocol")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "upload_protocol", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("pageToken")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "pageToken", valid_580339
  var valid_580340 = query.getOrDefault("quotaUser")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "quotaUser", valid_580340
  var valid_580341 = query.getOrDefault("alt")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("json"))
  if valid_580341 != nil:
    section.add "alt", valid_580341
  var valid_580342 = query.getOrDefault("oauth_token")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "oauth_token", valid_580342
  var valid_580343 = query.getOrDefault("callback")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "callback", valid_580343
  var valid_580344 = query.getOrDefault("access_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "access_token", valid_580344
  var valid_580345 = query.getOrDefault("uploadType")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "uploadType", valid_580345
  var valid_580346 = query.getOrDefault("orderBy")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "orderBy", valid_580346
  var valid_580347 = query.getOrDefault("key")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "key", valid_580347
  var valid_580348 = query.getOrDefault("$.xgafv")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("1"))
  if valid_580348 != nil:
    section.add "$.xgafv", valid_580348
  var valid_580349 = query.getOrDefault("pageSize")
  valid_580349 = validateParameter(valid_580349, JInt, required = false, default = nil)
  if valid_580349 != nil:
    section.add "pageSize", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  var valid_580351 = query.getOrDefault("filter")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "filter", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_CloudkmsProjectsLocationsKeyRingsList_580333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists KeyRings.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_CloudkmsProjectsLocationsKeyRingsList_580333;
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "pageToken", newJString(pageToken))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "callback", newJString(callback))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "uploadType", newJString(uploadType))
  add(path_580354, "parent", newJString(parent))
  add(query_580355, "orderBy", newJString(orderBy))
  add(query_580355, "key", newJString(key))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(query_580355, "pageSize", newJInt(pageSize))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "filter", newJString(filter))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsList* = Call_CloudkmsProjectsLocationsKeyRingsList_580333(
    name: "cloudkmsProjectsLocationsKeyRingsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsList_580334, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsList_580335, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580378 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580380(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580379(
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
  var valid_580381 = path.getOrDefault("resource")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "resource", valid_580381
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
  var valid_580382 = query.getOrDefault("upload_protocol")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "upload_protocol", valid_580382
  var valid_580383 = query.getOrDefault("fields")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "fields", valid_580383
  var valid_580384 = query.getOrDefault("quotaUser")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "quotaUser", valid_580384
  var valid_580385 = query.getOrDefault("alt")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("json"))
  if valid_580385 != nil:
    section.add "alt", valid_580385
  var valid_580386 = query.getOrDefault("oauth_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "oauth_token", valid_580386
  var valid_580387 = query.getOrDefault("callback")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "callback", valid_580387
  var valid_580388 = query.getOrDefault("access_token")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "access_token", valid_580388
  var valid_580389 = query.getOrDefault("uploadType")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "uploadType", valid_580389
  var valid_580390 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580390 = validateParameter(valid_580390, JInt, required = false, default = nil)
  if valid_580390 != nil:
    section.add "options.requestedPolicyVersion", valid_580390
  var valid_580391 = query.getOrDefault("key")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "key", valid_580391
  var valid_580392 = query.getOrDefault("$.xgafv")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("1"))
  if valid_580392 != nil:
    section.add "$.xgafv", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(true))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580394: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580394.validator(path, query, header, formData, body)
  let scheme = call_580394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580394.url(scheme.get, call_580394.host, call_580394.base,
                         call_580394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580394, url, valid)

proc call*(call_580395: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580378;
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
  var path_580396 = newJObject()
  var query_580397 = newJObject()
  add(query_580397, "upload_protocol", newJString(uploadProtocol))
  add(query_580397, "fields", newJString(fields))
  add(query_580397, "quotaUser", newJString(quotaUser))
  add(query_580397, "alt", newJString(alt))
  add(query_580397, "oauth_token", newJString(oauthToken))
  add(query_580397, "callback", newJString(callback))
  add(query_580397, "access_token", newJString(accessToken))
  add(query_580397, "uploadType", newJString(uploadType))
  add(query_580397, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580397, "key", newJString(key))
  add(query_580397, "$.xgafv", newJString(Xgafv))
  add(path_580396, "resource", newJString(resource))
  add(query_580397, "prettyPrint", newJBool(prettyPrint))
  result = call_580395.call(path_580396, query_580397, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580378(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:getIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580379,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysGetIamPolicy_580380,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580398 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580400(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580399(
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
  var valid_580401 = path.getOrDefault("resource")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "resource", valid_580401
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
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("access_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "access_token", valid_580408
  var valid_580409 = query.getOrDefault("uploadType")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "uploadType", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("$.xgafv")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("1"))
  if valid_580411 != nil:
    section.add "$.xgafv", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
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

proc call*(call_580414: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580398;
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
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  var body_580418 = newJObject()
  add(query_580417, "upload_protocol", newJString(uploadProtocol))
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "callback", newJString(callback))
  add(query_580417, "access_token", newJString(accessToken))
  add(query_580417, "uploadType", newJString(uploadType))
  add(query_580417, "key", newJString(key))
  add(query_580417, "$.xgafv", newJString(Xgafv))
  add(path_580416, "resource", newJString(resource))
  if body != nil:
    body_580418 = body
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  result = call_580415.call(path_580416, query_580417, nil, nil, body_580418)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580398(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:setIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580399,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysSetIamPolicy_580400,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580419 = ref object of OpenApiRestCall_579408
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580421(
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
  result.path = base & hydrated.get

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580420(
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
  var valid_580422 = path.getOrDefault("resource")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "resource", valid_580422
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
  var valid_580423 = query.getOrDefault("upload_protocol")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "upload_protocol", valid_580423
  var valid_580424 = query.getOrDefault("fields")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "fields", valid_580424
  var valid_580425 = query.getOrDefault("quotaUser")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "quotaUser", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("oauth_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "oauth_token", valid_580427
  var valid_580428 = query.getOrDefault("callback")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "callback", valid_580428
  var valid_580429 = query.getOrDefault("access_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "access_token", valid_580429
  var valid_580430 = query.getOrDefault("uploadType")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "uploadType", valid_580430
  var valid_580431 = query.getOrDefault("key")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "key", valid_580431
  var valid_580432 = query.getOrDefault("$.xgafv")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("1"))
  if valid_580432 != nil:
    section.add "$.xgafv", valid_580432
  var valid_580433 = query.getOrDefault("prettyPrint")
  valid_580433 = validateParameter(valid_580433, JBool, required = false,
                                 default = newJBool(true))
  if valid_580433 != nil:
    section.add "prettyPrint", valid_580433
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

proc call*(call_580435: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580419;
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
  let valid = call_580435.validator(path, query, header, formData, body)
  let scheme = call_580435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580435.url(scheme.get, call_580435.host, call_580435.base,
                         call_580435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580435, url, valid)

proc call*(call_580436: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580419;
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
  var path_580437 = newJObject()
  var query_580438 = newJObject()
  var body_580439 = newJObject()
  add(query_580438, "upload_protocol", newJString(uploadProtocol))
  add(query_580438, "fields", newJString(fields))
  add(query_580438, "quotaUser", newJString(quotaUser))
  add(query_580438, "alt", newJString(alt))
  add(query_580438, "oauth_token", newJString(oauthToken))
  add(query_580438, "callback", newJString(callback))
  add(query_580438, "access_token", newJString(accessToken))
  add(query_580438, "uploadType", newJString(uploadType))
  add(query_580438, "key", newJString(key))
  add(query_580438, "$.xgafv", newJString(Xgafv))
  add(path_580437, "resource", newJString(resource))
  if body != nil:
    body_580439 = body
  add(query_580438, "prettyPrint", newJBool(prettyPrint))
  result = call_580436.call(path_580437, query_580438, nil, nil, body_580439)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580419(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580420,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysTestIamPermissions_580421,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
