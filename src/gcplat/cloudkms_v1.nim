
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578610 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578611(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns metadata for a given ImportJob.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the ImportJob to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns metadata for a given ImportJob.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsGet
  ## Returns metadata for a given ImportJob.
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
  ##       : The name of the ImportJob to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsGet* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578610(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsGet",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578611,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsGet_578612,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578898 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578900(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578899(
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
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
  ##             : Required list of fields to be updated in this request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("updateMask")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "updateMask", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
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

proc call*(call_578915: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578898;
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
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578898;
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
  ##             : Required list of fields to be updated in this request.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  var body_578919 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(path_578917, "name", newJString(name))
  add(query_578918, "updateMask", newJString(updateMask))
  if body != nil:
    body_578919 = body
  add(query_578918, "callback", newJString(callback))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  result = call_578916.call(path_578917, query_578918, nil, nil, body_578919)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578898(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudkms.googleapis.com",
    route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578899,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_578900,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsList_578920 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsList_578922(protocol: Scheme; host: string;
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

proc validate_CloudkmsProjectsLocationsList_578921(path: JsonNode; query: JsonNode;
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
  var valid_578923 = path.getOrDefault("name")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "name", valid_578923
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
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("pageSize")
  valid_578928 = validateParameter(valid_578928, JInt, required = false, default = nil)
  if valid_578928 != nil:
    section.add "pageSize", valid_578928
  var valid_578929 = query.getOrDefault("alt")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("json"))
  if valid_578929 != nil:
    section.add "alt", valid_578929
  var valid_578930 = query.getOrDefault("uploadType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "uploadType", valid_578930
  var valid_578931 = query.getOrDefault("quotaUser")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "quotaUser", valid_578931
  var valid_578932 = query.getOrDefault("filter")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "filter", valid_578932
  var valid_578933 = query.getOrDefault("pageToken")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "pageToken", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_CloudkmsProjectsLocationsList_578920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_CloudkmsProjectsLocationsList_578920; name: string;
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
  var path_578940 = newJObject()
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(query_578941, "$.xgafv", newJString(Xgafv))
  add(query_578941, "pageSize", newJInt(pageSize))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "uploadType", newJString(uploadType))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(path_578940, "name", newJString(name))
  add(query_578941, "filter", newJString(filter))
  add(query_578941, "pageToken", newJString(pageToken))
  add(query_578941, "callback", newJString(callback))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "access_token", newJString(accessToken))
  add(query_578941, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(path_578940, query_578941, nil, nil, nil)

var cloudkmsProjectsLocationsList* = Call_CloudkmsProjectsLocationsList_578920(
    name: "cloudkmsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudkmsProjectsLocationsList_578921, base: "/",
    url: url_CloudkmsProjectsLocationsList_578922, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578942 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578944(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578943(
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
  var valid_578945 = path.getOrDefault("name")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "name", valid_578945
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
  var valid_578946 = query.getOrDefault("key")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "key", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
  var valid_578949 = query.getOrDefault("$.xgafv")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("1"))
  if valid_578949 != nil:
    section.add "$.xgafv", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("uploadType")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "uploadType", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("callback")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "callback", valid_578953
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
  var valid_578955 = query.getOrDefault("access_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "access_token", valid_578955
  var valid_578956 = query.getOrDefault("upload_protocol")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "upload_protocol", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578942;
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
  ##       : The name of the CryptoKeyVersion public key to
  ## get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "$.xgafv", newJString(Xgafv))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(path_578959, "name", newJString(name))
  add(query_578960, "callback", newJString(callback))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(path_578959, query_578960, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578942(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{name}/publicKey", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578943,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_578944,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578961 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578963(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578962(
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
  var valid_578964 = path.getOrDefault("name")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "name", valid_578964
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("$.xgafv")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("1"))
  if valid_578968 != nil:
    section.add "$.xgafv", valid_578968
  var valid_578969 = query.getOrDefault("alt")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("json"))
  if valid_578969 != nil:
    section.add "alt", valid_578969
  var valid_578970 = query.getOrDefault("uploadType")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "uploadType", valid_578970
  var valid_578971 = query.getOrDefault("quotaUser")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "quotaUser", valid_578971
  var valid_578972 = query.getOrDefault("callback")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "callback", valid_578972
  var valid_578973 = query.getOrDefault("fields")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "fields", valid_578973
  var valid_578974 = query.getOrDefault("access_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "access_token", valid_578974
  var valid_578975 = query.getOrDefault("upload_protocol")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "upload_protocol", valid_578975
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

proc call*(call_578977: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_578977.validator(path, query, header, formData, body)
  let scheme = call_578977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578977.url(scheme.get, call_578977.host, call_578977.base,
                         call_578977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578977, url, valid)

proc call*(call_578978: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578961;
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
  var path_578979 = newJObject()
  var query_578980 = newJObject()
  var body_578981 = newJObject()
  add(query_578980, "key", newJString(key))
  add(query_578980, "prettyPrint", newJBool(prettyPrint))
  add(query_578980, "oauth_token", newJString(oauthToken))
  add(query_578980, "$.xgafv", newJString(Xgafv))
  add(query_578980, "alt", newJString(alt))
  add(query_578980, "uploadType", newJString(uploadType))
  add(query_578980, "quotaUser", newJString(quotaUser))
  add(path_578979, "name", newJString(name))
  if body != nil:
    body_578981 = body
  add(query_578980, "callback", newJString(callback))
  add(query_578980, "fields", newJString(fields))
  add(query_578980, "access_token", newJString(accessToken))
  add(query_578980, "upload_protocol", newJString(uploadProtocol))
  result = call_578978.call(path_578979, query_578980, nil, nil, body_578981)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578961(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricDecrypt", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578962,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_578963,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578982 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578984(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578983(
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
  var valid_578985 = path.getOrDefault("name")
  valid_578985 = validateParameter(valid_578985, JString, required = true,
                                 default = nil)
  if valid_578985 != nil:
    section.add "name", valid_578985
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
  var valid_578986 = query.getOrDefault("key")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "key", valid_578986
  var valid_578987 = query.getOrDefault("prettyPrint")
  valid_578987 = validateParameter(valid_578987, JBool, required = false,
                                 default = newJBool(true))
  if valid_578987 != nil:
    section.add "prettyPrint", valid_578987
  var valid_578988 = query.getOrDefault("oauth_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "oauth_token", valid_578988
  var valid_578989 = query.getOrDefault("$.xgafv")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = newJString("1"))
  if valid_578989 != nil:
    section.add "$.xgafv", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("uploadType")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "uploadType", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("callback")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "callback", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  var valid_578995 = query.getOrDefault("access_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "access_token", valid_578995
  var valid_578996 = query.getOrDefault("upload_protocol")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "upload_protocol", valid_578996
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

proc call*(call_578998: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578982;
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
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  var body_579002 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(query_579001, "$.xgafv", newJString(Xgafv))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "uploadType", newJString(uploadType))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(path_579000, "name", newJString(name))
  if body != nil:
    body_579002 = body
  add(query_579001, "callback", newJString(callback))
  add(query_579001, "fields", newJString(fields))
  add(query_579001, "access_token", newJString(accessToken))
  add(query_579001, "upload_protocol", newJString(uploadProtocol))
  result = call_578999.call(path_579000, query_579001, nil, nil, body_579002)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578982(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricSign", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578983,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_578984,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579003 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579005(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579004(
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
  var valid_579006 = path.getOrDefault("name")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "name", valid_579006
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
  var valid_579007 = query.getOrDefault("key")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "key", valid_579007
  var valid_579008 = query.getOrDefault("prettyPrint")
  valid_579008 = validateParameter(valid_579008, JBool, required = false,
                                 default = newJBool(true))
  if valid_579008 != nil:
    section.add "prettyPrint", valid_579008
  var valid_579009 = query.getOrDefault("oauth_token")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "oauth_token", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("alt")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("json"))
  if valid_579011 != nil:
    section.add "alt", valid_579011
  var valid_579012 = query.getOrDefault("uploadType")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "uploadType", valid_579012
  var valid_579013 = query.getOrDefault("quotaUser")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "quotaUser", valid_579013
  var valid_579014 = query.getOrDefault("callback")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "callback", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  var valid_579016 = query.getOrDefault("access_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "access_token", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
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

proc call*(call_579019: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579003;
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
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  var body_579023 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "name", newJString(name))
  if body != nil:
    body_579023 = body
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "access_token", newJString(accessToken))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  result = call_579020.call(path_579021, query_579022, nil, nil, body_579023)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579003(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:decrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579004,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_579005,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579024 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579026(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579025(
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
  var valid_579027 = path.getOrDefault("name")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "name", valid_579027
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
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("$.xgafv")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("1"))
  if valid_579031 != nil:
    section.add "$.xgafv", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("uploadType")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "uploadType", valid_579033
  var valid_579034 = query.getOrDefault("quotaUser")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "quotaUser", valid_579034
  var valid_579035 = query.getOrDefault("callback")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "callback", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  var valid_579037 = query.getOrDefault("access_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "access_token", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
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

proc call*(call_579040: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579024;
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
  let valid = call_579040.validator(path, query, header, formData, body)
  let scheme = call_579040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579040.url(scheme.get, call_579040.host, call_579040.base,
                         call_579040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579040, url, valid)

proc call*(call_579041: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579024;
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
  ##       : The resource name of the CryptoKeyVersion to destroy.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579042 = newJObject()
  var query_579043 = newJObject()
  var body_579044 = newJObject()
  add(query_579043, "key", newJString(key))
  add(query_579043, "prettyPrint", newJBool(prettyPrint))
  add(query_579043, "oauth_token", newJString(oauthToken))
  add(query_579043, "$.xgafv", newJString(Xgafv))
  add(query_579043, "alt", newJString(alt))
  add(query_579043, "uploadType", newJString(uploadType))
  add(query_579043, "quotaUser", newJString(quotaUser))
  add(path_579042, "name", newJString(name))
  if body != nil:
    body_579044 = body
  add(query_579043, "callback", newJString(callback))
  add(query_579043, "fields", newJString(fields))
  add(query_579043, "access_token", newJString(accessToken))
  add(query_579043, "upload_protocol", newJString(uploadProtocol))
  result = call_579041.call(path_579042, query_579043, nil, nil, body_579044)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579024(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:destroy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579025,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_579026,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579045 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579047(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579046(
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
  var valid_579048 = path.getOrDefault("name")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "name", valid_579048
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
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("$.xgafv")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("1"))
  if valid_579052 != nil:
    section.add "$.xgafv", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("uploadType")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "uploadType", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("callback")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "callback", valid_579056
  var valid_579057 = query.getOrDefault("fields")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "fields", valid_579057
  var valid_579058 = query.getOrDefault("access_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "access_token", valid_579058
  var valid_579059 = query.getOrDefault("upload_protocol")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "upload_protocol", valid_579059
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

proc call*(call_579061: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579045;
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
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  var body_579065 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "$.xgafv", newJString(Xgafv))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "uploadType", newJString(uploadType))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(path_579063, "name", newJString(name))
  if body != nil:
    body_579065 = body
  add(query_579064, "callback", newJString(callback))
  add(query_579064, "fields", newJString(fields))
  add(query_579064, "access_token", newJString(accessToken))
  add(query_579064, "upload_protocol", newJString(uploadProtocol))
  result = call_579062.call(path_579063, query_579064, nil, nil, body_579065)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579045(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:encrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579046,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_579047,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579066 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579068(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579067(
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
  var valid_579069 = path.getOrDefault("name")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "name", valid_579069
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
  var valid_579070 = query.getOrDefault("key")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "key", valid_579070
  var valid_579071 = query.getOrDefault("prettyPrint")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "prettyPrint", valid_579071
  var valid_579072 = query.getOrDefault("oauth_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "oauth_token", valid_579072
  var valid_579073 = query.getOrDefault("$.xgafv")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("1"))
  if valid_579073 != nil:
    section.add "$.xgafv", valid_579073
  var valid_579074 = query.getOrDefault("alt")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("json"))
  if valid_579074 != nil:
    section.add "alt", valid_579074
  var valid_579075 = query.getOrDefault("uploadType")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "uploadType", valid_579075
  var valid_579076 = query.getOrDefault("quotaUser")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "quotaUser", valid_579076
  var valid_579077 = query.getOrDefault("callback")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "callback", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
  var valid_579079 = query.getOrDefault("access_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "access_token", valid_579079
  var valid_579080 = query.getOrDefault("upload_protocol")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "upload_protocol", valid_579080
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

proc call*(call_579082: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579066;
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
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579066;
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
  ##       : The resource name of the CryptoKeyVersion to restore.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  var body_579086 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "name", newJString(name))
  if body != nil:
    body_579086 = body
  add(query_579085, "callback", newJString(callback))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "access_token", newJString(accessToken))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  result = call_579083.call(path_579084, query_579085, nil, nil, body_579086)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579066(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:restore", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579067,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_579068,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579087 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579089(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579088(
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
  var valid_579090 = path.getOrDefault("name")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "name", valid_579090
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
  var valid_579091 = query.getOrDefault("key")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "key", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("$.xgafv")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("1"))
  if valid_579094 != nil:
    section.add "$.xgafv", valid_579094
  var valid_579095 = query.getOrDefault("alt")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("json"))
  if valid_579095 != nil:
    section.add "alt", valid_579095
  var valid_579096 = query.getOrDefault("uploadType")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "uploadType", valid_579096
  var valid_579097 = query.getOrDefault("quotaUser")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "quotaUser", valid_579097
  var valid_579098 = query.getOrDefault("callback")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "callback", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  var valid_579100 = query.getOrDefault("access_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "access_token", valid_579100
  var valid_579101 = query.getOrDefault("upload_protocol")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "upload_protocol", valid_579101
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

proc call*(call_579103: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579087;
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
  ##       : The resource name of the CryptoKey to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  var body_579107 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "$.xgafv", newJString(Xgafv))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "uploadType", newJString(uploadType))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "name", newJString(name))
  if body != nil:
    body_579107 = body
  add(query_579106, "callback", newJString(callback))
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "access_token", newJString(accessToken))
  add(query_579106, "upload_protocol", newJString(uploadProtocol))
  result = call_579104.call(path_579105, query_579106, nil, nil, body_579107)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579087(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:updatePrimaryVersion", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579088,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_579089,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579132 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579134(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579133(
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
  var valid_579135 = path.getOrDefault("parent")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "parent", valid_579135
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
  var valid_579136 = query.getOrDefault("key")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "key", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("$.xgafv")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("1"))
  if valid_579139 != nil:
    section.add "$.xgafv", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("uploadType")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "uploadType", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("callback")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "callback", valid_579143
  var valid_579144 = query.getOrDefault("fields")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "fields", valid_579144
  var valid_579145 = query.getOrDefault("access_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "access_token", valid_579145
  var valid_579146 = query.getOrDefault("upload_protocol")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "upload_protocol", valid_579146
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

proc call*(call_579148: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579132;
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
  var path_579150 = newJObject()
  var query_579151 = newJObject()
  var body_579152 = newJObject()
  add(query_579151, "key", newJString(key))
  add(query_579151, "prettyPrint", newJBool(prettyPrint))
  add(query_579151, "oauth_token", newJString(oauthToken))
  add(query_579151, "$.xgafv", newJString(Xgafv))
  add(query_579151, "alt", newJString(alt))
  add(query_579151, "uploadType", newJString(uploadType))
  add(query_579151, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579152 = body
  add(query_579151, "callback", newJString(callback))
  add(path_579150, "parent", newJString(parent))
  add(query_579151, "fields", newJString(fields))
  add(query_579151, "access_token", newJString(accessToken))
  add(query_579151, "upload_protocol", newJString(uploadProtocol))
  result = call_579149.call(path_579150, query_579151, nil, nil, body_579152)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579132(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579133,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_579134,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579108 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579110(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579109(
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
  var valid_579111 = path.getOrDefault("parent")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "parent", valid_579111
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
  ##           : Optional limit on the number of CryptoKeyVersions to
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
  ##            : Optional pagination token, returned earlier via
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
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("$.xgafv")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("1"))
  if valid_579115 != nil:
    section.add "$.xgafv", valid_579115
  var valid_579116 = query.getOrDefault("pageSize")
  valid_579116 = validateParameter(valid_579116, JInt, required = false, default = nil)
  if valid_579116 != nil:
    section.add "pageSize", valid_579116
  var valid_579117 = query.getOrDefault("alt")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("json"))
  if valid_579117 != nil:
    section.add "alt", valid_579117
  var valid_579118 = query.getOrDefault("uploadType")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "uploadType", valid_579118
  var valid_579119 = query.getOrDefault("quotaUser")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "quotaUser", valid_579119
  var valid_579120 = query.getOrDefault("orderBy")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "orderBy", valid_579120
  var valid_579121 = query.getOrDefault("filter")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "filter", valid_579121
  var valid_579122 = query.getOrDefault("pageToken")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "pageToken", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
  var valid_579127 = query.getOrDefault("view")
  valid_579127 = validateParameter(valid_579127, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_579127 != nil:
    section.add "view", valid_579127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579128: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeyVersions.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579108;
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
  ##           : Optional limit on the number of CryptoKeyVersions to
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
  ##            : Optional pagination token, returned earlier via
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
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(query_579131, "$.xgafv", newJString(Xgafv))
  add(query_579131, "pageSize", newJInt(pageSize))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "uploadType", newJString(uploadType))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(query_579131, "orderBy", newJString(orderBy))
  add(query_579131, "filter", newJString(filter))
  add(query_579131, "pageToken", newJString(pageToken))
  add(query_579131, "callback", newJString(callback))
  add(path_579130, "parent", newJString(parent))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "access_token", newJString(accessToken))
  add(query_579131, "upload_protocol", newJString(uploadProtocol))
  add(query_579131, "view", newJString(view))
  result = call_579129.call(path_579130, query_579131, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579108(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579109,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_579110,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579153 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579155(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579154(
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
  var valid_579156 = path.getOrDefault("parent")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "parent", valid_579156
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
  var valid_579157 = query.getOrDefault("key")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "key", valid_579157
  var valid_579158 = query.getOrDefault("prettyPrint")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "prettyPrint", valid_579158
  var valid_579159 = query.getOrDefault("oauth_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "oauth_token", valid_579159
  var valid_579160 = query.getOrDefault("$.xgafv")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("1"))
  if valid_579160 != nil:
    section.add "$.xgafv", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("uploadType")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "uploadType", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("callback")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "callback", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
  var valid_579166 = query.getOrDefault("access_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "access_token", valid_579166
  var valid_579167 = query.getOrDefault("upload_protocol")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "upload_protocol", valid_579167
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

proc call*(call_579169: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  let valid = call_579169.validator(path, query, header, formData, body)
  let scheme = call_579169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579169.url(scheme.get, call_579169.host, call_579169.base,
                         call_579169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579169, url, valid)

proc call*(call_579170: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579153;
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
  var path_579171 = newJObject()
  var query_579172 = newJObject()
  var body_579173 = newJObject()
  add(query_579172, "key", newJString(key))
  add(query_579172, "prettyPrint", newJBool(prettyPrint))
  add(query_579172, "oauth_token", newJString(oauthToken))
  add(query_579172, "$.xgafv", newJString(Xgafv))
  add(query_579172, "alt", newJString(alt))
  add(query_579172, "uploadType", newJString(uploadType))
  add(query_579172, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579173 = body
  add(query_579172, "callback", newJString(callback))
  add(path_579171, "parent", newJString(parent))
  add(query_579172, "fields", newJString(fields))
  add(query_579172, "access_token", newJString(accessToken))
  add(query_579172, "upload_protocol", newJString(uploadProtocol))
  result = call_579170.call(path_579171, query_579172, nil, nil, body_579173)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579153(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions:import", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579154,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_579155,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579198 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579200(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579199(
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
  var valid_579201 = path.getOrDefault("parent")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "parent", valid_579201
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
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("$.xgafv")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("1"))
  if valid_579205 != nil:
    section.add "$.xgafv", valid_579205
  var valid_579206 = query.getOrDefault("alt")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = newJString("json"))
  if valid_579206 != nil:
    section.add "alt", valid_579206
  var valid_579207 = query.getOrDefault("uploadType")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "uploadType", valid_579207
  var valid_579208 = query.getOrDefault("quotaUser")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "quotaUser", valid_579208
  var valid_579209 = query.getOrDefault("cryptoKeyId")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "cryptoKeyId", valid_579209
  var valid_579210 = query.getOrDefault("skipInitialVersionCreation")
  valid_579210 = validateParameter(valid_579210, JBool, required = false, default = nil)
  if valid_579210 != nil:
    section.add "skipInitialVersionCreation", valid_579210
  var valid_579211 = query.getOrDefault("callback")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "callback", valid_579211
  var valid_579212 = query.getOrDefault("fields")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "fields", valid_579212
  var valid_579213 = query.getOrDefault("access_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "access_token", valid_579213
  var valid_579214 = query.getOrDefault("upload_protocol")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "upload_protocol", valid_579214
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

proc call*(call_579216: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  let valid = call_579216.validator(path, query, header, formData, body)
  let scheme = call_579216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579216.url(scheme.get, call_579216.host, call_579216.base,
                         call_579216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579216, url, valid)

proc call*(call_579217: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579198;
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
  var path_579218 = newJObject()
  var query_579219 = newJObject()
  var body_579220 = newJObject()
  add(query_579219, "key", newJString(key))
  add(query_579219, "prettyPrint", newJBool(prettyPrint))
  add(query_579219, "oauth_token", newJString(oauthToken))
  add(query_579219, "$.xgafv", newJString(Xgafv))
  add(query_579219, "alt", newJString(alt))
  add(query_579219, "uploadType", newJString(uploadType))
  add(query_579219, "quotaUser", newJString(quotaUser))
  add(query_579219, "cryptoKeyId", newJString(cryptoKeyId))
  add(query_579219, "skipInitialVersionCreation",
      newJBool(skipInitialVersionCreation))
  if body != nil:
    body_579220 = body
  add(query_579219, "callback", newJString(callback))
  add(path_579218, "parent", newJString(parent))
  add(query_579219, "fields", newJString(fields))
  add(query_579219, "access_token", newJString(accessToken))
  add(query_579219, "upload_protocol", newJString(uploadProtocol))
  result = call_579217.call(path_579218, query_579219, nil, nil, body_579220)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579198(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579199,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_579200,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579174 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579176(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579175(
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
  var valid_579177 = path.getOrDefault("parent")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "parent", valid_579177
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
  ##           : Optional limit on the number of CryptoKeys to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("prettyPrint")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "prettyPrint", valid_579179
  var valid_579180 = query.getOrDefault("oauth_token")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "oauth_token", valid_579180
  var valid_579181 = query.getOrDefault("versionView")
  valid_579181 = validateParameter(valid_579181, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_579181 != nil:
    section.add "versionView", valid_579181
  var valid_579182 = query.getOrDefault("$.xgafv")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("1"))
  if valid_579182 != nil:
    section.add "$.xgafv", valid_579182
  var valid_579183 = query.getOrDefault("pageSize")
  valid_579183 = validateParameter(valid_579183, JInt, required = false, default = nil)
  if valid_579183 != nil:
    section.add "pageSize", valid_579183
  var valid_579184 = query.getOrDefault("alt")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("json"))
  if valid_579184 != nil:
    section.add "alt", valid_579184
  var valid_579185 = query.getOrDefault("uploadType")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "uploadType", valid_579185
  var valid_579186 = query.getOrDefault("quotaUser")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "quotaUser", valid_579186
  var valid_579187 = query.getOrDefault("orderBy")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "orderBy", valid_579187
  var valid_579188 = query.getOrDefault("filter")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "filter", valid_579188
  var valid_579189 = query.getOrDefault("pageToken")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "pageToken", valid_579189
  var valid_579190 = query.getOrDefault("callback")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "callback", valid_579190
  var valid_579191 = query.getOrDefault("fields")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "fields", valid_579191
  var valid_579192 = query.getOrDefault("access_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "access_token", valid_579192
  var valid_579193 = query.getOrDefault("upload_protocol")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "upload_protocol", valid_579193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579194: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeys.
  ## 
  let valid = call_579194.validator(path, query, header, formData, body)
  let scheme = call_579194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579194.url(scheme.get, call_579194.host, call_579194.base,
                         call_579194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579194, url, valid)

proc call*(call_579195: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579174;
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
  ##           : Optional limit on the number of CryptoKeys to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var path_579196 = newJObject()
  var query_579197 = newJObject()
  add(query_579197, "key", newJString(key))
  add(query_579197, "prettyPrint", newJBool(prettyPrint))
  add(query_579197, "oauth_token", newJString(oauthToken))
  add(query_579197, "versionView", newJString(versionView))
  add(query_579197, "$.xgafv", newJString(Xgafv))
  add(query_579197, "pageSize", newJInt(pageSize))
  add(query_579197, "alt", newJString(alt))
  add(query_579197, "uploadType", newJString(uploadType))
  add(query_579197, "quotaUser", newJString(quotaUser))
  add(query_579197, "orderBy", newJString(orderBy))
  add(query_579197, "filter", newJString(filter))
  add(query_579197, "pageToken", newJString(pageToken))
  add(query_579197, "callback", newJString(callback))
  add(path_579196, "parent", newJString(parent))
  add(query_579197, "fields", newJString(fields))
  add(query_579197, "access_token", newJString(accessToken))
  add(query_579197, "upload_protocol", newJString(uploadProtocol))
  result = call_579195.call(path_579196, query_579197, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579174(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579175,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_579176,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579244 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579246(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579245(
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
  var valid_579247 = path.getOrDefault("parent")
  valid_579247 = validateParameter(valid_579247, JString, required = true,
                                 default = nil)
  if valid_579247 != nil:
    section.add "parent", valid_579247
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
  var valid_579248 = query.getOrDefault("key")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "key", valid_579248
  var valid_579249 = query.getOrDefault("prettyPrint")
  valid_579249 = validateParameter(valid_579249, JBool, required = false,
                                 default = newJBool(true))
  if valid_579249 != nil:
    section.add "prettyPrint", valid_579249
  var valid_579250 = query.getOrDefault("oauth_token")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "oauth_token", valid_579250
  var valid_579251 = query.getOrDefault("$.xgafv")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = newJString("1"))
  if valid_579251 != nil:
    section.add "$.xgafv", valid_579251
  var valid_579252 = query.getOrDefault("alt")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = newJString("json"))
  if valid_579252 != nil:
    section.add "alt", valid_579252
  var valid_579253 = query.getOrDefault("uploadType")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "uploadType", valid_579253
  var valid_579254 = query.getOrDefault("quotaUser")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "quotaUser", valid_579254
  var valid_579255 = query.getOrDefault("callback")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "callback", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
  var valid_579257 = query.getOrDefault("access_token")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "access_token", valid_579257
  var valid_579258 = query.getOrDefault("upload_protocol")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "upload_protocol", valid_579258
  var valid_579259 = query.getOrDefault("importJobId")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "importJobId", valid_579259
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

proc call*(call_579261: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  let valid = call_579261.validator(path, query, header, formData, body)
  let scheme = call_579261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579261.url(scheme.get, call_579261.host, call_579261.base,
                         call_579261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579261, url, valid)

proc call*(call_579262: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579244;
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
  var path_579263 = newJObject()
  var query_579264 = newJObject()
  var body_579265 = newJObject()
  add(query_579264, "key", newJString(key))
  add(query_579264, "prettyPrint", newJBool(prettyPrint))
  add(query_579264, "oauth_token", newJString(oauthToken))
  add(query_579264, "$.xgafv", newJString(Xgafv))
  add(query_579264, "alt", newJString(alt))
  add(query_579264, "uploadType", newJString(uploadType))
  add(query_579264, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579265 = body
  add(query_579264, "callback", newJString(callback))
  add(path_579263, "parent", newJString(parent))
  add(query_579264, "fields", newJString(fields))
  add(query_579264, "access_token", newJString(accessToken))
  add(query_579264, "upload_protocol", newJString(uploadProtocol))
  add(query_579264, "importJobId", newJString(importJobId))
  result = call_579262.call(path_579263, query_579264, nil, nil, body_579265)

var cloudkmsProjectsLocationsKeyRingsImportJobsCreate* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579244(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579245,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_579246,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_579221 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsList_579223(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_579222(
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
  var valid_579224 = path.getOrDefault("parent")
  valid_579224 = validateParameter(valid_579224, JString, required = true,
                                 default = nil)
  if valid_579224 != nil:
    section.add "parent", valid_579224
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
  ##           : Optional limit on the number of ImportJobs to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var valid_579225 = query.getOrDefault("key")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "key", valid_579225
  var valid_579226 = query.getOrDefault("prettyPrint")
  valid_579226 = validateParameter(valid_579226, JBool, required = false,
                                 default = newJBool(true))
  if valid_579226 != nil:
    section.add "prettyPrint", valid_579226
  var valid_579227 = query.getOrDefault("oauth_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "oauth_token", valid_579227
  var valid_579228 = query.getOrDefault("$.xgafv")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("1"))
  if valid_579228 != nil:
    section.add "$.xgafv", valid_579228
  var valid_579229 = query.getOrDefault("pageSize")
  valid_579229 = validateParameter(valid_579229, JInt, required = false, default = nil)
  if valid_579229 != nil:
    section.add "pageSize", valid_579229
  var valid_579230 = query.getOrDefault("alt")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = newJString("json"))
  if valid_579230 != nil:
    section.add "alt", valid_579230
  var valid_579231 = query.getOrDefault("uploadType")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "uploadType", valid_579231
  var valid_579232 = query.getOrDefault("quotaUser")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "quotaUser", valid_579232
  var valid_579233 = query.getOrDefault("orderBy")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "orderBy", valid_579233
  var valid_579234 = query.getOrDefault("filter")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "filter", valid_579234
  var valid_579235 = query.getOrDefault("pageToken")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "pageToken", valid_579235
  var valid_579236 = query.getOrDefault("callback")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "callback", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  var valid_579238 = query.getOrDefault("access_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "access_token", valid_579238
  var valid_579239 = query.getOrDefault("upload_protocol")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "upload_protocol", valid_579239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579240: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_579221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ImportJobs.
  ## 
  let valid = call_579240.validator(path, query, header, formData, body)
  let scheme = call_579240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579240.url(scheme.get, call_579240.host, call_579240.base,
                         call_579240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579240, url, valid)

proc call*(call_579241: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_579221;
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
  ##           : Optional limit on the number of ImportJobs to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var path_579242 = newJObject()
  var query_579243 = newJObject()
  add(query_579243, "key", newJString(key))
  add(query_579243, "prettyPrint", newJBool(prettyPrint))
  add(query_579243, "oauth_token", newJString(oauthToken))
  add(query_579243, "$.xgafv", newJString(Xgafv))
  add(query_579243, "pageSize", newJInt(pageSize))
  add(query_579243, "alt", newJString(alt))
  add(query_579243, "uploadType", newJString(uploadType))
  add(query_579243, "quotaUser", newJString(quotaUser))
  add(query_579243, "orderBy", newJString(orderBy))
  add(query_579243, "filter", newJString(filter))
  add(query_579243, "pageToken", newJString(pageToken))
  add(query_579243, "callback", newJString(callback))
  add(path_579242, "parent", newJString(parent))
  add(query_579243, "fields", newJString(fields))
  add(query_579243, "access_token", newJString(accessToken))
  add(query_579243, "upload_protocol", newJString(uploadProtocol))
  result = call_579241.call(path_579242, query_579243, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsList* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_579221(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_579222,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsList_579223,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCreate_579289 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsCreate_579291(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsCreate_579290(path: JsonNode;
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
  var valid_579292 = path.getOrDefault("parent")
  valid_579292 = validateParameter(valid_579292, JString, required = true,
                                 default = nil)
  if valid_579292 != nil:
    section.add "parent", valid_579292
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
  var valid_579293 = query.getOrDefault("key")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "key", valid_579293
  var valid_579294 = query.getOrDefault("prettyPrint")
  valid_579294 = validateParameter(valid_579294, JBool, required = false,
                                 default = newJBool(true))
  if valid_579294 != nil:
    section.add "prettyPrint", valid_579294
  var valid_579295 = query.getOrDefault("oauth_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "oauth_token", valid_579295
  var valid_579296 = query.getOrDefault("$.xgafv")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("1"))
  if valid_579296 != nil:
    section.add "$.xgafv", valid_579296
  var valid_579297 = query.getOrDefault("alt")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = newJString("json"))
  if valid_579297 != nil:
    section.add "alt", valid_579297
  var valid_579298 = query.getOrDefault("uploadType")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "uploadType", valid_579298
  var valid_579299 = query.getOrDefault("quotaUser")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "quotaUser", valid_579299
  var valid_579300 = query.getOrDefault("keyRingId")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "keyRingId", valid_579300
  var valid_579301 = query.getOrDefault("callback")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "callback", valid_579301
  var valid_579302 = query.getOrDefault("fields")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "fields", valid_579302
  var valid_579303 = query.getOrDefault("access_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "access_token", valid_579303
  var valid_579304 = query.getOrDefault("upload_protocol")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "upload_protocol", valid_579304
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

proc call*(call_579306: Call_CloudkmsProjectsLocationsKeyRingsCreate_579289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  let valid = call_579306.validator(path, query, header, formData, body)
  let scheme = call_579306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579306.url(scheme.get, call_579306.host, call_579306.base,
                         call_579306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579306, url, valid)

proc call*(call_579307: Call_CloudkmsProjectsLocationsKeyRingsCreate_579289;
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
  var path_579308 = newJObject()
  var query_579309 = newJObject()
  var body_579310 = newJObject()
  add(query_579309, "key", newJString(key))
  add(query_579309, "prettyPrint", newJBool(prettyPrint))
  add(query_579309, "oauth_token", newJString(oauthToken))
  add(query_579309, "$.xgafv", newJString(Xgafv))
  add(query_579309, "alt", newJString(alt))
  add(query_579309, "uploadType", newJString(uploadType))
  add(query_579309, "quotaUser", newJString(quotaUser))
  add(query_579309, "keyRingId", newJString(keyRingId))
  if body != nil:
    body_579310 = body
  add(query_579309, "callback", newJString(callback))
  add(path_579308, "parent", newJString(parent))
  add(query_579309, "fields", newJString(fields))
  add(query_579309, "access_token", newJString(accessToken))
  add(query_579309, "upload_protocol", newJString(uploadProtocol))
  result = call_579307.call(path_579308, query_579309, nil, nil, body_579310)

var cloudkmsProjectsLocationsKeyRingsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCreate_579289(
    name: "cloudkmsProjectsLocationsKeyRingsCreate", meth: HttpMethod.HttpPost,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCreate_579290, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCreate_579291,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsList_579266 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsList_579268(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsList_579267(path: JsonNode;
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
  var valid_579269 = path.getOrDefault("parent")
  valid_579269 = validateParameter(valid_579269, JString, required = true,
                                 default = nil)
  if valid_579269 != nil:
    section.add "parent", valid_579269
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
  ##           : Optional limit on the number of KeyRings to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var valid_579270 = query.getOrDefault("key")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "key", valid_579270
  var valid_579271 = query.getOrDefault("prettyPrint")
  valid_579271 = validateParameter(valid_579271, JBool, required = false,
                                 default = newJBool(true))
  if valid_579271 != nil:
    section.add "prettyPrint", valid_579271
  var valid_579272 = query.getOrDefault("oauth_token")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "oauth_token", valid_579272
  var valid_579273 = query.getOrDefault("$.xgafv")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("1"))
  if valid_579273 != nil:
    section.add "$.xgafv", valid_579273
  var valid_579274 = query.getOrDefault("pageSize")
  valid_579274 = validateParameter(valid_579274, JInt, required = false, default = nil)
  if valid_579274 != nil:
    section.add "pageSize", valid_579274
  var valid_579275 = query.getOrDefault("alt")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("json"))
  if valid_579275 != nil:
    section.add "alt", valid_579275
  var valid_579276 = query.getOrDefault("uploadType")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "uploadType", valid_579276
  var valid_579277 = query.getOrDefault("quotaUser")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "quotaUser", valid_579277
  var valid_579278 = query.getOrDefault("orderBy")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "orderBy", valid_579278
  var valid_579279 = query.getOrDefault("filter")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "filter", valid_579279
  var valid_579280 = query.getOrDefault("pageToken")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "pageToken", valid_579280
  var valid_579281 = query.getOrDefault("callback")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "callback", valid_579281
  var valid_579282 = query.getOrDefault("fields")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "fields", valid_579282
  var valid_579283 = query.getOrDefault("access_token")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "access_token", valid_579283
  var valid_579284 = query.getOrDefault("upload_protocol")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "upload_protocol", valid_579284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579285: Call_CloudkmsProjectsLocationsKeyRingsList_579266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists KeyRings.
  ## 
  let valid = call_579285.validator(path, query, header, formData, body)
  let scheme = call_579285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579285.url(scheme.get, call_579285.host, call_579285.base,
                         call_579285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579285, url, valid)

proc call*(call_579286: Call_CloudkmsProjectsLocationsKeyRingsList_579266;
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
  ##           : Optional limit on the number of KeyRings to include in the
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
  ##            : Optional pagination token, returned earlier via
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
  var path_579287 = newJObject()
  var query_579288 = newJObject()
  add(query_579288, "key", newJString(key))
  add(query_579288, "prettyPrint", newJBool(prettyPrint))
  add(query_579288, "oauth_token", newJString(oauthToken))
  add(query_579288, "$.xgafv", newJString(Xgafv))
  add(query_579288, "pageSize", newJInt(pageSize))
  add(query_579288, "alt", newJString(alt))
  add(query_579288, "uploadType", newJString(uploadType))
  add(query_579288, "quotaUser", newJString(quotaUser))
  add(query_579288, "orderBy", newJString(orderBy))
  add(query_579288, "filter", newJString(filter))
  add(query_579288, "pageToken", newJString(pageToken))
  add(query_579288, "callback", newJString(callback))
  add(path_579287, "parent", newJString(parent))
  add(query_579288, "fields", newJString(fields))
  add(query_579288, "access_token", newJString(accessToken))
  add(query_579288, "upload_protocol", newJString(uploadProtocol))
  result = call_579286.call(path_579287, query_579288, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsList* = Call_CloudkmsProjectsLocationsKeyRingsList_579266(
    name: "cloudkmsProjectsLocationsKeyRingsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsList_579267, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsList_579268, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579311 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579313(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579312(
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
  var valid_579314 = path.getOrDefault("resource")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "resource", valid_579314
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
  var valid_579315 = query.getOrDefault("key")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "key", valid_579315
  var valid_579316 = query.getOrDefault("prettyPrint")
  valid_579316 = validateParameter(valid_579316, JBool, required = false,
                                 default = newJBool(true))
  if valid_579316 != nil:
    section.add "prettyPrint", valid_579316
  var valid_579317 = query.getOrDefault("oauth_token")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "oauth_token", valid_579317
  var valid_579318 = query.getOrDefault("$.xgafv")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("1"))
  if valid_579318 != nil:
    section.add "$.xgafv", valid_579318
  var valid_579319 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579319 = validateParameter(valid_579319, JInt, required = false, default = nil)
  if valid_579319 != nil:
    section.add "options.requestedPolicyVersion", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("uploadType")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "uploadType", valid_579321
  var valid_579322 = query.getOrDefault("quotaUser")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "quotaUser", valid_579322
  var valid_579323 = query.getOrDefault("callback")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "callback", valid_579323
  var valid_579324 = query.getOrDefault("fields")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "fields", valid_579324
  var valid_579325 = query.getOrDefault("access_token")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "access_token", valid_579325
  var valid_579326 = query.getOrDefault("upload_protocol")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "upload_protocol", valid_579326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579327: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579327.validator(path, query, header, formData, body)
  let scheme = call_579327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579327.url(scheme.get, call_579327.host, call_579327.base,
                         call_579327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579327, url, valid)

proc call*(call_579328: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579311;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy
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
  var path_579329 = newJObject()
  var query_579330 = newJObject()
  add(query_579330, "key", newJString(key))
  add(query_579330, "prettyPrint", newJBool(prettyPrint))
  add(query_579330, "oauth_token", newJString(oauthToken))
  add(query_579330, "$.xgafv", newJString(Xgafv))
  add(query_579330, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579330, "alt", newJString(alt))
  add(query_579330, "uploadType", newJString(uploadType))
  add(query_579330, "quotaUser", newJString(quotaUser))
  add(path_579329, "resource", newJString(resource))
  add(query_579330, "callback", newJString(callback))
  add(query_579330, "fields", newJString(fields))
  add(query_579330, "access_token", newJString(accessToken))
  add(query_579330, "upload_protocol", newJString(uploadProtocol))
  result = call_579328.call(path_579329, query_579330, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579311(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:getIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579312,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_579313,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579331 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579333(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579332(
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
  var valid_579334 = path.getOrDefault("resource")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "resource", valid_579334
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
  var valid_579335 = query.getOrDefault("key")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "key", valid_579335
  var valid_579336 = query.getOrDefault("prettyPrint")
  valid_579336 = validateParameter(valid_579336, JBool, required = false,
                                 default = newJBool(true))
  if valid_579336 != nil:
    section.add "prettyPrint", valid_579336
  var valid_579337 = query.getOrDefault("oauth_token")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "oauth_token", valid_579337
  var valid_579338 = query.getOrDefault("$.xgafv")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = newJString("1"))
  if valid_579338 != nil:
    section.add "$.xgafv", valid_579338
  var valid_579339 = query.getOrDefault("alt")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = newJString("json"))
  if valid_579339 != nil:
    section.add "alt", valid_579339
  var valid_579340 = query.getOrDefault("uploadType")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "uploadType", valid_579340
  var valid_579341 = query.getOrDefault("quotaUser")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "quotaUser", valid_579341
  var valid_579342 = query.getOrDefault("callback")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "callback", valid_579342
  var valid_579343 = query.getOrDefault("fields")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "fields", valid_579343
  var valid_579344 = query.getOrDefault("access_token")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "access_token", valid_579344
  var valid_579345 = query.getOrDefault("upload_protocol")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "upload_protocol", valid_579345
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

proc call*(call_579347: Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579347.validator(path, query, header, formData, body)
  let scheme = call_579347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579347.url(scheme.get, call_579347.host, call_579347.base,
                         call_579347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579347, url, valid)

proc call*(call_579348: Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579331;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  var path_579349 = newJObject()
  var query_579350 = newJObject()
  var body_579351 = newJObject()
  add(query_579350, "key", newJString(key))
  add(query_579350, "prettyPrint", newJBool(prettyPrint))
  add(query_579350, "oauth_token", newJString(oauthToken))
  add(query_579350, "$.xgafv", newJString(Xgafv))
  add(query_579350, "alt", newJString(alt))
  add(query_579350, "uploadType", newJString(uploadType))
  add(query_579350, "quotaUser", newJString(quotaUser))
  add(path_579349, "resource", newJString(resource))
  if body != nil:
    body_579351 = body
  add(query_579350, "callback", newJString(callback))
  add(query_579350, "fields", newJString(fields))
  add(query_579350, "access_token", newJString(accessToken))
  add(query_579350, "upload_protocol", newJString(uploadProtocol))
  result = call_579348.call(path_579349, query_579350, nil, nil, body_579351)

var cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579331(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:setIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579332,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_579333,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579352 = ref object of OpenApiRestCall_578339
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579354(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579353(
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
  var valid_579355 = path.getOrDefault("resource")
  valid_579355 = validateParameter(valid_579355, JString, required = true,
                                 default = nil)
  if valid_579355 != nil:
    section.add "resource", valid_579355
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
  var valid_579356 = query.getOrDefault("key")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "key", valid_579356
  var valid_579357 = query.getOrDefault("prettyPrint")
  valid_579357 = validateParameter(valid_579357, JBool, required = false,
                                 default = newJBool(true))
  if valid_579357 != nil:
    section.add "prettyPrint", valid_579357
  var valid_579358 = query.getOrDefault("oauth_token")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "oauth_token", valid_579358
  var valid_579359 = query.getOrDefault("$.xgafv")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = newJString("1"))
  if valid_579359 != nil:
    section.add "$.xgafv", valid_579359
  var valid_579360 = query.getOrDefault("alt")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = newJString("json"))
  if valid_579360 != nil:
    section.add "alt", valid_579360
  var valid_579361 = query.getOrDefault("uploadType")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "uploadType", valid_579361
  var valid_579362 = query.getOrDefault("quotaUser")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "quotaUser", valid_579362
  var valid_579363 = query.getOrDefault("callback")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "callback", valid_579363
  var valid_579364 = query.getOrDefault("fields")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "fields", valid_579364
  var valid_579365 = query.getOrDefault("access_token")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "access_token", valid_579365
  var valid_579366 = query.getOrDefault("upload_protocol")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "upload_protocol", valid_579366
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

proc call*(call_579368: Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579352;
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
  let valid = call_579368.validator(path, query, header, formData, body)
  let scheme = call_579368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579368.url(scheme.get, call_579368.host, call_579368.base,
                         call_579368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579368, url, valid)

proc call*(call_579369: Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579352;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions
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
  var path_579370 = newJObject()
  var query_579371 = newJObject()
  var body_579372 = newJObject()
  add(query_579371, "key", newJString(key))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(query_579371, "$.xgafv", newJString(Xgafv))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "uploadType", newJString(uploadType))
  add(query_579371, "quotaUser", newJString(quotaUser))
  add(path_579370, "resource", newJString(resource))
  if body != nil:
    body_579372 = body
  add(query_579371, "callback", newJString(callback))
  add(query_579371, "fields", newJString(fields))
  add(query_579371, "access_token", newJString(accessToken))
  add(query_579371, "upload_protocol", newJString(uploadProtocol))
  result = call_579369.call(path_579370, query_579371, nil, nil, body_579372)

var cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579352(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579353,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_579354,
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
