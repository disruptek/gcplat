
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588710 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588712(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588711(
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns metadata for a given ImportJob.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsGet
  ## Returns metadata for a given ImportJob.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the ImportJob to get.
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsGet* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588710(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsGet",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588711,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsGet_588712,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588998 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_589000(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588999(
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
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  var valid_589013 = query.getOrDefault("updateMask")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "updateMask", valid_589013
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

proc call*(call_589015: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588998;
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
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588998;
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
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  var body_589019 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(path_589017, "name", newJString(name))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(query_589018, "key", newJString(key))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589019 = body
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  add(query_589018, "updateMask", newJString(updateMask))
  result = call_589016.call(path_589017, query_589018, nil, nil, body_589019)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588998(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch",
    meth: HttpMethod.HttpPatch, host: "cloudkms.googleapis.com",
    route: "/v1/{name}", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_588999,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsPatch_589000,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsList_589020 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsList_589022(protocol: Scheme; host: string;
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

proc validate_CloudkmsProjectsLocationsList_589021(path: JsonNode; query: JsonNode;
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
  var valid_589023 = path.getOrDefault("name")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "name", valid_589023
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
  var valid_589024 = query.getOrDefault("upload_protocol")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "upload_protocol", valid_589024
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("pageToken")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "pageToken", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("pageSize")
  valid_589035 = validateParameter(valid_589035, JInt, required = false, default = nil)
  if valid_589035 != nil:
    section.add "pageSize", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  var valid_589037 = query.getOrDefault("filter")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "filter", valid_589037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589038: Call_CloudkmsProjectsLocationsList_589020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_CloudkmsProjectsLocationsList_589020; name: string;
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
  var path_589040 = newJObject()
  var query_589041 = newJObject()
  add(query_589041, "upload_protocol", newJString(uploadProtocol))
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "pageToken", newJString(pageToken))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(path_589040, "name", newJString(name))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(query_589041, "callback", newJString(callback))
  add(query_589041, "access_token", newJString(accessToken))
  add(query_589041, "uploadType", newJString(uploadType))
  add(query_589041, "key", newJString(key))
  add(query_589041, "$.xgafv", newJString(Xgafv))
  add(query_589041, "pageSize", newJInt(pageSize))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  add(query_589041, "filter", newJString(filter))
  result = call_589039.call(path_589040, query_589041, nil, nil, nil)

var cloudkmsProjectsLocationsList* = Call_CloudkmsProjectsLocationsList_589020(
    name: "cloudkmsProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_CloudkmsProjectsLocationsList_589021, base: "/",
    url: url_CloudkmsProjectsLocationsList_589022, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589042 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589044(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589043(
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
  var valid_589045 = path.getOrDefault("name")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "name", valid_589045
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
  var valid_589046 = query.getOrDefault("upload_protocol")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "upload_protocol", valid_589046
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("callback")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callback", valid_589051
  var valid_589052 = query.getOrDefault("access_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "access_token", valid_589052
  var valid_589053 = query.getOrDefault("uploadType")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "uploadType", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("$.xgafv")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("1"))
  if valid_589055 != nil:
    section.add "$.xgafv", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the public key for the given CryptoKeyVersion. The
  ## CryptoKey.purpose must be
  ## ASYMMETRIC_SIGN or
  ## ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589042;
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
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(path_589059, "name", newJString(name))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589042(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{name}/publicKey", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589043,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsGetPublicKey_589044,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589061 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589063(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589062(
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
  var valid_589064 = path.getOrDefault("name")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "name", valid_589064
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
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("oauth_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "oauth_token", valid_589069
  var valid_589070 = query.getOrDefault("callback")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "callback", valid_589070
  var valid_589071 = query.getOrDefault("access_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "access_token", valid_589071
  var valid_589072 = query.getOrDefault("uploadType")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "uploadType", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("$.xgafv")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("1"))
  if valid_589074 != nil:
    section.add "$.xgafv", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
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

proc call*(call_589077: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was encrypted with a public key retrieved from
  ## GetPublicKey corresponding to a CryptoKeyVersion with
  ## CryptoKey.purpose ASYMMETRIC_DECRYPT.
  ## 
  let valid = call_589077.validator(path, query, header, formData, body)
  let scheme = call_589077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589077.url(scheme.get, call_589077.host, call_589077.base,
                         call_589077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589077, url, valid)

proc call*(call_589078: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589061;
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
  var path_589079 = newJObject()
  var query_589080 = newJObject()
  var body_589081 = newJObject()
  add(query_589080, "upload_protocol", newJString(uploadProtocol))
  add(query_589080, "fields", newJString(fields))
  add(query_589080, "quotaUser", newJString(quotaUser))
  add(path_589079, "name", newJString(name))
  add(query_589080, "alt", newJString(alt))
  add(query_589080, "oauth_token", newJString(oauthToken))
  add(query_589080, "callback", newJString(callback))
  add(query_589080, "access_token", newJString(accessToken))
  add(query_589080, "uploadType", newJString(uploadType))
  add(query_589080, "key", newJString(key))
  add(query_589080, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589081 = body
  add(query_589080, "prettyPrint", newJBool(prettyPrint))
  result = call_589078.call(path_589079, query_589080, nil, nil, body_589081)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589061(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricDecrypt", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589062,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricDecrypt_589063,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589082 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589084(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589083(
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
  var valid_589085 = path.getOrDefault("name")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "name", valid_589085
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
  var valid_589086 = query.getOrDefault("upload_protocol")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "upload_protocol", valid_589086
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("callback")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "callback", valid_589091
  var valid_589092 = query.getOrDefault("access_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "access_token", valid_589092
  var valid_589093 = query.getOrDefault("uploadType")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "uploadType", valid_589093
  var valid_589094 = query.getOrDefault("key")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "key", valid_589094
  var valid_589095 = query.getOrDefault("$.xgafv")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("1"))
  if valid_589095 != nil:
    section.add "$.xgafv", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
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

proc call*(call_589098: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Signs data using a CryptoKeyVersion with CryptoKey.purpose
  ## ASYMMETRIC_SIGN, producing a signature that can be verified with the public
  ## key retrieved from GetPublicKey.
  ## 
  let valid = call_589098.validator(path, query, header, formData, body)
  let scheme = call_589098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589098.url(scheme.get, call_589098.host, call_589098.base,
                         call_589098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589098, url, valid)

proc call*(call_589099: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589082;
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
  var path_589100 = newJObject()
  var query_589101 = newJObject()
  var body_589102 = newJObject()
  add(query_589101, "upload_protocol", newJString(uploadProtocol))
  add(query_589101, "fields", newJString(fields))
  add(query_589101, "quotaUser", newJString(quotaUser))
  add(path_589100, "name", newJString(name))
  add(query_589101, "alt", newJString(alt))
  add(query_589101, "oauth_token", newJString(oauthToken))
  add(query_589101, "callback", newJString(callback))
  add(query_589101, "access_token", newJString(accessToken))
  add(query_589101, "uploadType", newJString(uploadType))
  add(query_589101, "key", newJString(key))
  add(query_589101, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589102 = body
  add(query_589101, "prettyPrint", newJBool(prettyPrint))
  result = call_589099.call(path_589100, query_589101, nil, nil, body_589102)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589082(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:asymmetricSign", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589083,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsAsymmetricSign_589084,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589103 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589105(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589104(
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
  var valid_589106 = path.getOrDefault("name")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "name", valid_589106
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
  var valid_589107 = query.getOrDefault("upload_protocol")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "upload_protocol", valid_589107
  var valid_589108 = query.getOrDefault("fields")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "fields", valid_589108
  var valid_589109 = query.getOrDefault("quotaUser")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "quotaUser", valid_589109
  var valid_589110 = query.getOrDefault("alt")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("json"))
  if valid_589110 != nil:
    section.add "alt", valid_589110
  var valid_589111 = query.getOrDefault("oauth_token")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "oauth_token", valid_589111
  var valid_589112 = query.getOrDefault("callback")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "callback", valid_589112
  var valid_589113 = query.getOrDefault("access_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "access_token", valid_589113
  var valid_589114 = query.getOrDefault("uploadType")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "uploadType", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("$.xgafv")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("1"))
  if valid_589116 != nil:
    section.add "$.xgafv", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
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

proc call*(call_589119: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Decrypts data that was protected by Encrypt. The CryptoKey.purpose
  ## must be ENCRYPT_DECRYPT.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589103;
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  var body_589123 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "name", newJString(name))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589123 = body
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, body_589123)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589103(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:decrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589104,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysDecrypt_589105,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589124 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589126(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589125(
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
  var valid_589127 = path.getOrDefault("name")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "name", valid_589127
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
  var valid_589128 = query.getOrDefault("upload_protocol")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "upload_protocol", valid_589128
  var valid_589129 = query.getOrDefault("fields")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "fields", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("callback")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "callback", valid_589133
  var valid_589134 = query.getOrDefault("access_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "access_token", valid_589134
  var valid_589135 = query.getOrDefault("uploadType")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "uploadType", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("$.xgafv")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("1"))
  if valid_589137 != nil:
    section.add "$.xgafv", valid_589137
  var valid_589138 = query.getOrDefault("prettyPrint")
  valid_589138 = validateParameter(valid_589138, JBool, required = false,
                                 default = newJBool(true))
  if valid_589138 != nil:
    section.add "prettyPrint", valid_589138
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

proc call*(call_589140: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589124;
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
  let valid = call_589140.validator(path, query, header, formData, body)
  let scheme = call_589140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589140.url(scheme.get, call_589140.host, call_589140.base,
                         call_589140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589140, url, valid)

proc call*(call_589141: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589124;
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
  var path_589142 = newJObject()
  var query_589143 = newJObject()
  var body_589144 = newJObject()
  add(query_589143, "upload_protocol", newJString(uploadProtocol))
  add(query_589143, "fields", newJString(fields))
  add(query_589143, "quotaUser", newJString(quotaUser))
  add(path_589142, "name", newJString(name))
  add(query_589143, "alt", newJString(alt))
  add(query_589143, "oauth_token", newJString(oauthToken))
  add(query_589143, "callback", newJString(callback))
  add(query_589143, "access_token", newJString(accessToken))
  add(query_589143, "uploadType", newJString(uploadType))
  add(query_589143, "key", newJString(key))
  add(query_589143, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589144 = body
  add(query_589143, "prettyPrint", newJBool(prettyPrint))
  result = call_589141.call(path_589142, query_589143, nil, nil, body_589144)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589124(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:destroy", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589125,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsDestroy_589126,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589145 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589147(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589146(
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
  var valid_589148 = path.getOrDefault("name")
  valid_589148 = validateParameter(valid_589148, JString, required = true,
                                 default = nil)
  if valid_589148 != nil:
    section.add "name", valid_589148
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
  var valid_589149 = query.getOrDefault("upload_protocol")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "upload_protocol", valid_589149
  var valid_589150 = query.getOrDefault("fields")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "fields", valid_589150
  var valid_589151 = query.getOrDefault("quotaUser")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "quotaUser", valid_589151
  var valid_589152 = query.getOrDefault("alt")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("json"))
  if valid_589152 != nil:
    section.add "alt", valid_589152
  var valid_589153 = query.getOrDefault("oauth_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "oauth_token", valid_589153
  var valid_589154 = query.getOrDefault("callback")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "callback", valid_589154
  var valid_589155 = query.getOrDefault("access_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "access_token", valid_589155
  var valid_589156 = query.getOrDefault("uploadType")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "uploadType", valid_589156
  var valid_589157 = query.getOrDefault("key")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "key", valid_589157
  var valid_589158 = query.getOrDefault("$.xgafv")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("1"))
  if valid_589158 != nil:
    section.add "$.xgafv", valid_589158
  var valid_589159 = query.getOrDefault("prettyPrint")
  valid_589159 = validateParameter(valid_589159, JBool, required = false,
                                 default = newJBool(true))
  if valid_589159 != nil:
    section.add "prettyPrint", valid_589159
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

proc call*(call_589161: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Encrypts data, so that it can only be recovered by a call to Decrypt.
  ## The CryptoKey.purpose must be
  ## ENCRYPT_DECRYPT.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589145;
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
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  var body_589165 = newJObject()
  add(query_589164, "upload_protocol", newJString(uploadProtocol))
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(path_589163, "name", newJString(name))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "callback", newJString(callback))
  add(query_589164, "access_token", newJString(accessToken))
  add(query_589164, "uploadType", newJString(uploadType))
  add(query_589164, "key", newJString(key))
  add(query_589164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589165 = body
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(path_589163, query_589164, nil, nil, body_589165)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589145(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:encrypt",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589146,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysEncrypt_589147,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589166 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589168(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589167(
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
  var valid_589169 = path.getOrDefault("name")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "name", valid_589169
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
  var valid_589170 = query.getOrDefault("upload_protocol")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "upload_protocol", valid_589170
  var valid_589171 = query.getOrDefault("fields")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "fields", valid_589171
  var valid_589172 = query.getOrDefault("quotaUser")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "quotaUser", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("oauth_token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "oauth_token", valid_589174
  var valid_589175 = query.getOrDefault("callback")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "callback", valid_589175
  var valid_589176 = query.getOrDefault("access_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "access_token", valid_589176
  var valid_589177 = query.getOrDefault("uploadType")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "uploadType", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("$.xgafv")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("1"))
  if valid_589179 != nil:
    section.add "$.xgafv", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
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

proc call*(call_589182: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589166;
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
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589166;
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  var body_589186 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(path_589184, "name", newJString(name))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589186 = body
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, body_589186)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589166(name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:restore", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589167,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsRestore_589168,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589187 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589189(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589188(
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
  var valid_589190 = path.getOrDefault("name")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "name", valid_589190
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
  var valid_589191 = query.getOrDefault("upload_protocol")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "upload_protocol", valid_589191
  var valid_589192 = query.getOrDefault("fields")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "fields", valid_589192
  var valid_589193 = query.getOrDefault("quotaUser")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "quotaUser", valid_589193
  var valid_589194 = query.getOrDefault("alt")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("json"))
  if valid_589194 != nil:
    section.add "alt", valid_589194
  var valid_589195 = query.getOrDefault("oauth_token")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "oauth_token", valid_589195
  var valid_589196 = query.getOrDefault("callback")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "callback", valid_589196
  var valid_589197 = query.getOrDefault("access_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "access_token", valid_589197
  var valid_589198 = query.getOrDefault("uploadType")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "uploadType", valid_589198
  var valid_589199 = query.getOrDefault("key")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "key", valid_589199
  var valid_589200 = query.getOrDefault("$.xgafv")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = newJString("1"))
  if valid_589200 != nil:
    section.add "$.xgafv", valid_589200
  var valid_589201 = query.getOrDefault("prettyPrint")
  valid_589201 = validateParameter(valid_589201, JBool, required = false,
                                 default = newJBool(true))
  if valid_589201 != nil:
    section.add "prettyPrint", valid_589201
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

proc call*(call_589203: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the version of a CryptoKey that will be used in Encrypt.
  ## 
  ## Returns an error if called on an asymmetric key.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589187;
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
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  var body_589207 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(path_589205, "name", newJString(name))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(query_589206, "key", newJString(key))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589207 = body
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, body_589207)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589187(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{name}:updatePrimaryVersion", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589188,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysUpdatePrimaryVersion_589189,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589232 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589234(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589233(
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
  var valid_589235 = path.getOrDefault("parent")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "parent", valid_589235
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
  var valid_589236 = query.getOrDefault("upload_protocol")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "upload_protocol", valid_589236
  var valid_589237 = query.getOrDefault("fields")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "fields", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("callback")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "callback", valid_589241
  var valid_589242 = query.getOrDefault("access_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "access_token", valid_589242
  var valid_589243 = query.getOrDefault("uploadType")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "uploadType", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("$.xgafv")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("1"))
  if valid_589245 != nil:
    section.add "$.xgafv", valid_589245
  var valid_589246 = query.getOrDefault("prettyPrint")
  valid_589246 = validateParameter(valid_589246, JBool, required = false,
                                 default = newJBool(true))
  if valid_589246 != nil:
    section.add "prettyPrint", valid_589246
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

proc call*(call_589248: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKeyVersion in a CryptoKey.
  ## 
  ## The server will assign the next sequential id. If unset,
  ## state will be set to
  ## ENABLED.
  ## 
  let valid = call_589248.validator(path, query, header, formData, body)
  let scheme = call_589248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589248.url(scheme.get, call_589248.host, call_589248.base,
                         call_589248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589248, url, valid)

proc call*(call_589249: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589232;
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
  var path_589250 = newJObject()
  var query_589251 = newJObject()
  var body_589252 = newJObject()
  add(query_589251, "upload_protocol", newJString(uploadProtocol))
  add(query_589251, "fields", newJString(fields))
  add(query_589251, "quotaUser", newJString(quotaUser))
  add(query_589251, "alt", newJString(alt))
  add(query_589251, "oauth_token", newJString(oauthToken))
  add(query_589251, "callback", newJString(callback))
  add(query_589251, "access_token", newJString(accessToken))
  add(query_589251, "uploadType", newJString(uploadType))
  add(path_589250, "parent", newJString(parent))
  add(query_589251, "key", newJString(key))
  add(query_589251, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589252 = body
  add(query_589251, "prettyPrint", newJBool(prettyPrint))
  result = call_589249.call(path_589250, query_589251, nil, nil, body_589252)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589232(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589233,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsCreate_589234,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589208 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589210(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589209(
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
  var valid_589211 = path.getOrDefault("parent")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "parent", valid_589211
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
  var valid_589212 = query.getOrDefault("upload_protocol")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "upload_protocol", valid_589212
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("pageToken")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "pageToken", valid_589214
  var valid_589215 = query.getOrDefault("quotaUser")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "quotaUser", valid_589215
  var valid_589216 = query.getOrDefault("view")
  valid_589216 = validateParameter(valid_589216, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_589216 != nil:
    section.add "view", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("callback")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "callback", valid_589219
  var valid_589220 = query.getOrDefault("access_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "access_token", valid_589220
  var valid_589221 = query.getOrDefault("uploadType")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "uploadType", valid_589221
  var valid_589222 = query.getOrDefault("orderBy")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "orderBy", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("$.xgafv")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("1"))
  if valid_589224 != nil:
    section.add "$.xgafv", valid_589224
  var valid_589225 = query.getOrDefault("pageSize")
  valid_589225 = validateParameter(valid_589225, JInt, required = false, default = nil)
  if valid_589225 != nil:
    section.add "pageSize", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
  var valid_589227 = query.getOrDefault("filter")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "filter", valid_589227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589228: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeyVersions.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589208;
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
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  add(query_589231, "upload_protocol", newJString(uploadProtocol))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "pageToken", newJString(pageToken))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "view", newJString(view))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "callback", newJString(callback))
  add(query_589231, "access_token", newJString(accessToken))
  add(query_589231, "uploadType", newJString(uploadType))
  add(path_589230, "parent", newJString(parent))
  add(query_589231, "orderBy", newJString(orderBy))
  add(query_589231, "key", newJString(key))
  add(query_589231, "$.xgafv", newJString(Xgafv))
  add(query_589231, "pageSize", newJInt(pageSize))
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  add(query_589231, "filter", newJString(filter))
  result = call_589229.call(path_589230, query_589231, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589208(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589209,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsList_589210,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589253 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589255(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589254(
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
  var valid_589256 = path.getOrDefault("parent")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "parent", valid_589256
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
  var valid_589257 = query.getOrDefault("upload_protocol")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "upload_protocol", valid_589257
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("callback")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "callback", valid_589262
  var valid_589263 = query.getOrDefault("access_token")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "access_token", valid_589263
  var valid_589264 = query.getOrDefault("uploadType")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "uploadType", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("$.xgafv")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("1"))
  if valid_589266 != nil:
    section.add "$.xgafv", valid_589266
  var valid_589267 = query.getOrDefault("prettyPrint")
  valid_589267 = validateParameter(valid_589267, JBool, required = false,
                                 default = newJBool(true))
  if valid_589267 != nil:
    section.add "prettyPrint", valid_589267
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

proc call*(call_589269: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports a new CryptoKeyVersion into an existing CryptoKey using the
  ## wrapped key material provided in the request.
  ## 
  ## The version ID will be assigned the next sequential id within the
  ## CryptoKey.
  ## 
  let valid = call_589269.validator(path, query, header, formData, body)
  let scheme = call_589269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589269.url(scheme.get, call_589269.host, call_589269.base,
                         call_589269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589269, url, valid)

proc call*(call_589270: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589253;
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
  var path_589271 = newJObject()
  var query_589272 = newJObject()
  var body_589273 = newJObject()
  add(query_589272, "upload_protocol", newJString(uploadProtocol))
  add(query_589272, "fields", newJString(fields))
  add(query_589272, "quotaUser", newJString(quotaUser))
  add(query_589272, "alt", newJString(alt))
  add(query_589272, "oauth_token", newJString(oauthToken))
  add(query_589272, "callback", newJString(callback))
  add(query_589272, "access_token", newJString(accessToken))
  add(query_589272, "uploadType", newJString(uploadType))
  add(path_589271, "parent", newJString(parent))
  add(query_589272, "key", newJString(key))
  add(query_589272, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589273 = body
  add(query_589272, "prettyPrint", newJBool(prettyPrint))
  result = call_589270.call(path_589271, query_589272, nil, nil, body_589273)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589253(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeyVersions:import", validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589254,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCryptoKeyVersionsImport_589255,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589298 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589300(
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589299(
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
  var valid_589301 = path.getOrDefault("parent")
  valid_589301 = validateParameter(valid_589301, JString, required = true,
                                 default = nil)
  if valid_589301 != nil:
    section.add "parent", valid_589301
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
  var valid_589302 = query.getOrDefault("upload_protocol")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "upload_protocol", valid_589302
  var valid_589303 = query.getOrDefault("fields")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "fields", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("cryptoKeyId")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "cryptoKeyId", valid_589306
  var valid_589307 = query.getOrDefault("oauth_token")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "oauth_token", valid_589307
  var valid_589308 = query.getOrDefault("callback")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "callback", valid_589308
  var valid_589309 = query.getOrDefault("access_token")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "access_token", valid_589309
  var valid_589310 = query.getOrDefault("uploadType")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "uploadType", valid_589310
  var valid_589311 = query.getOrDefault("skipInitialVersionCreation")
  valid_589311 = validateParameter(valid_589311, JBool, required = false, default = nil)
  if valid_589311 != nil:
    section.add "skipInitialVersionCreation", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("$.xgafv")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("1"))
  if valid_589313 != nil:
    section.add "$.xgafv", valid_589313
  var valid_589314 = query.getOrDefault("prettyPrint")
  valid_589314 = validateParameter(valid_589314, JBool, required = false,
                                 default = newJBool(true))
  if valid_589314 != nil:
    section.add "prettyPrint", valid_589314
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

proc call*(call_589316: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new CryptoKey within a KeyRing.
  ## 
  ## CryptoKey.purpose and
  ## CryptoKey.version_template.algorithm
  ## are required.
  ## 
  let valid = call_589316.validator(path, query, header, formData, body)
  let scheme = call_589316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589316.url(scheme.get, call_589316.host, call_589316.base,
                         call_589316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589316, url, valid)

proc call*(call_589317: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589298;
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
  var path_589318 = newJObject()
  var query_589319 = newJObject()
  var body_589320 = newJObject()
  add(query_589319, "upload_protocol", newJString(uploadProtocol))
  add(query_589319, "fields", newJString(fields))
  add(query_589319, "quotaUser", newJString(quotaUser))
  add(query_589319, "alt", newJString(alt))
  add(query_589319, "cryptoKeyId", newJString(cryptoKeyId))
  add(query_589319, "oauth_token", newJString(oauthToken))
  add(query_589319, "callback", newJString(callback))
  add(query_589319, "access_token", newJString(accessToken))
  add(query_589319, "uploadType", newJString(uploadType))
  add(path_589318, "parent", newJString(parent))
  add(query_589319, "skipInitialVersionCreation",
      newJBool(skipInitialVersionCreation))
  add(query_589319, "key", newJString(key))
  add(query_589319, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589320 = body
  add(query_589319, "prettyPrint", newJBool(prettyPrint))
  result = call_589317.call(path_589318, query_589319, nil, nil, body_589320)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589298(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589299,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysCreate_589300,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589274 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589276(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589275(
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
  var valid_589277 = path.getOrDefault("parent")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "parent", valid_589277
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
  var valid_589278 = query.getOrDefault("upload_protocol")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "upload_protocol", valid_589278
  var valid_589279 = query.getOrDefault("fields")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "fields", valid_589279
  var valid_589280 = query.getOrDefault("pageToken")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "pageToken", valid_589280
  var valid_589281 = query.getOrDefault("quotaUser")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "quotaUser", valid_589281
  var valid_589282 = query.getOrDefault("alt")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("json"))
  if valid_589282 != nil:
    section.add "alt", valid_589282
  var valid_589283 = query.getOrDefault("oauth_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "oauth_token", valid_589283
  var valid_589284 = query.getOrDefault("callback")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "callback", valid_589284
  var valid_589285 = query.getOrDefault("access_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "access_token", valid_589285
  var valid_589286 = query.getOrDefault("uploadType")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "uploadType", valid_589286
  var valid_589287 = query.getOrDefault("versionView")
  valid_589287 = validateParameter(valid_589287, JString, required = false, default = newJString(
      "CRYPTO_KEY_VERSION_VIEW_UNSPECIFIED"))
  if valid_589287 != nil:
    section.add "versionView", valid_589287
  var valid_589288 = query.getOrDefault("orderBy")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "orderBy", valid_589288
  var valid_589289 = query.getOrDefault("key")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "key", valid_589289
  var valid_589290 = query.getOrDefault("$.xgafv")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("1"))
  if valid_589290 != nil:
    section.add "$.xgafv", valid_589290
  var valid_589291 = query.getOrDefault("pageSize")
  valid_589291 = validateParameter(valid_589291, JInt, required = false, default = nil)
  if valid_589291 != nil:
    section.add "pageSize", valid_589291
  var valid_589292 = query.getOrDefault("prettyPrint")
  valid_589292 = validateParameter(valid_589292, JBool, required = false,
                                 default = newJBool(true))
  if valid_589292 != nil:
    section.add "prettyPrint", valid_589292
  var valid_589293 = query.getOrDefault("filter")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "filter", valid_589293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589294: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists CryptoKeys.
  ## 
  let valid = call_589294.validator(path, query, header, formData, body)
  let scheme = call_589294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589294.url(scheme.get, call_589294.host, call_589294.base,
                         call_589294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589294, url, valid)

proc call*(call_589295: Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589274;
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
  var path_589296 = newJObject()
  var query_589297 = newJObject()
  add(query_589297, "upload_protocol", newJString(uploadProtocol))
  add(query_589297, "fields", newJString(fields))
  add(query_589297, "pageToken", newJString(pageToken))
  add(query_589297, "quotaUser", newJString(quotaUser))
  add(query_589297, "alt", newJString(alt))
  add(query_589297, "oauth_token", newJString(oauthToken))
  add(query_589297, "callback", newJString(callback))
  add(query_589297, "access_token", newJString(accessToken))
  add(query_589297, "uploadType", newJString(uploadType))
  add(path_589296, "parent", newJString(parent))
  add(query_589297, "versionView", newJString(versionView))
  add(query_589297, "orderBy", newJString(orderBy))
  add(query_589297, "key", newJString(key))
  add(query_589297, "$.xgafv", newJString(Xgafv))
  add(query_589297, "pageSize", newJInt(pageSize))
  add(query_589297, "prettyPrint", newJBool(prettyPrint))
  add(query_589297, "filter", newJString(filter))
  result = call_589295.call(path_589296, query_589297, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsCryptoKeysList* = Call_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589274(
    name: "cloudkmsProjectsLocationsKeyRingsCryptoKeysList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/cryptoKeys",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589275,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsCryptoKeysList_589276,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589344 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589346(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589345(
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
  var valid_589347 = path.getOrDefault("parent")
  valid_589347 = validateParameter(valid_589347, JString, required = true,
                                 default = nil)
  if valid_589347 != nil:
    section.add "parent", valid_589347
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
  var valid_589348 = query.getOrDefault("upload_protocol")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "upload_protocol", valid_589348
  var valid_589349 = query.getOrDefault("fields")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "fields", valid_589349
  var valid_589350 = query.getOrDefault("quotaUser")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "quotaUser", valid_589350
  var valid_589351 = query.getOrDefault("alt")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = newJString("json"))
  if valid_589351 != nil:
    section.add "alt", valid_589351
  var valid_589352 = query.getOrDefault("importJobId")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "importJobId", valid_589352
  var valid_589353 = query.getOrDefault("oauth_token")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "oauth_token", valid_589353
  var valid_589354 = query.getOrDefault("callback")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "callback", valid_589354
  var valid_589355 = query.getOrDefault("access_token")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "access_token", valid_589355
  var valid_589356 = query.getOrDefault("uploadType")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "uploadType", valid_589356
  var valid_589357 = query.getOrDefault("key")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "key", valid_589357
  var valid_589358 = query.getOrDefault("$.xgafv")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = newJString("1"))
  if valid_589358 != nil:
    section.add "$.xgafv", valid_589358
  var valid_589359 = query.getOrDefault("prettyPrint")
  valid_589359 = validateParameter(valid_589359, JBool, required = false,
                                 default = newJBool(true))
  if valid_589359 != nil:
    section.add "prettyPrint", valid_589359
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

proc call*(call_589361: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589344;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new ImportJob within a KeyRing.
  ## 
  ## ImportJob.import_method is required.
  ## 
  let valid = call_589361.validator(path, query, header, formData, body)
  let scheme = call_589361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589361.url(scheme.get, call_589361.host, call_589361.base,
                         call_589361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589361, url, valid)

proc call*(call_589362: Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589344;
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
  var path_589363 = newJObject()
  var query_589364 = newJObject()
  var body_589365 = newJObject()
  add(query_589364, "upload_protocol", newJString(uploadProtocol))
  add(query_589364, "fields", newJString(fields))
  add(query_589364, "quotaUser", newJString(quotaUser))
  add(query_589364, "alt", newJString(alt))
  add(query_589364, "importJobId", newJString(importJobId))
  add(query_589364, "oauth_token", newJString(oauthToken))
  add(query_589364, "callback", newJString(callback))
  add(query_589364, "access_token", newJString(accessToken))
  add(query_589364, "uploadType", newJString(uploadType))
  add(path_589363, "parent", newJString(parent))
  add(query_589364, "key", newJString(key))
  add(query_589364, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589365 = body
  add(query_589364, "prettyPrint", newJBool(prettyPrint))
  result = call_589362.call(path_589363, query_589364, nil, nil, body_589365)

var cloudkmsProjectsLocationsKeyRingsImportJobsCreate* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589344(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsCreate",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589345,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsCreate_589346,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_589321 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsList_589323(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_589322(
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
  var valid_589324 = path.getOrDefault("parent")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "parent", valid_589324
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
  var valid_589325 = query.getOrDefault("upload_protocol")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "upload_protocol", valid_589325
  var valid_589326 = query.getOrDefault("fields")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "fields", valid_589326
  var valid_589327 = query.getOrDefault("pageToken")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "pageToken", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("alt")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("json"))
  if valid_589329 != nil:
    section.add "alt", valid_589329
  var valid_589330 = query.getOrDefault("oauth_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "oauth_token", valid_589330
  var valid_589331 = query.getOrDefault("callback")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "callback", valid_589331
  var valid_589332 = query.getOrDefault("access_token")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "access_token", valid_589332
  var valid_589333 = query.getOrDefault("uploadType")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "uploadType", valid_589333
  var valid_589334 = query.getOrDefault("orderBy")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "orderBy", valid_589334
  var valid_589335 = query.getOrDefault("key")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "key", valid_589335
  var valid_589336 = query.getOrDefault("$.xgafv")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = newJString("1"))
  if valid_589336 != nil:
    section.add "$.xgafv", valid_589336
  var valid_589337 = query.getOrDefault("pageSize")
  valid_589337 = validateParameter(valid_589337, JInt, required = false, default = nil)
  if valid_589337 != nil:
    section.add "pageSize", valid_589337
  var valid_589338 = query.getOrDefault("prettyPrint")
  valid_589338 = validateParameter(valid_589338, JBool, required = false,
                                 default = newJBool(true))
  if valid_589338 != nil:
    section.add "prettyPrint", valid_589338
  var valid_589339 = query.getOrDefault("filter")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "filter", valid_589339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589340: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_589321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ImportJobs.
  ## 
  let valid = call_589340.validator(path, query, header, formData, body)
  let scheme = call_589340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589340.url(scheme.get, call_589340.host, call_589340.base,
                         call_589340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589340, url, valid)

proc call*(call_589341: Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_589321;
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
  var path_589342 = newJObject()
  var query_589343 = newJObject()
  add(query_589343, "upload_protocol", newJString(uploadProtocol))
  add(query_589343, "fields", newJString(fields))
  add(query_589343, "pageToken", newJString(pageToken))
  add(query_589343, "quotaUser", newJString(quotaUser))
  add(query_589343, "alt", newJString(alt))
  add(query_589343, "oauth_token", newJString(oauthToken))
  add(query_589343, "callback", newJString(callback))
  add(query_589343, "access_token", newJString(accessToken))
  add(query_589343, "uploadType", newJString(uploadType))
  add(path_589342, "parent", newJString(parent))
  add(query_589343, "orderBy", newJString(orderBy))
  add(query_589343, "key", newJString(key))
  add(query_589343, "$.xgafv", newJString(Xgafv))
  add(query_589343, "pageSize", newJInt(pageSize))
  add(query_589343, "prettyPrint", newJBool(prettyPrint))
  add(query_589343, "filter", newJString(filter))
  result = call_589341.call(path_589342, query_589343, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsList* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsList_589321(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsList",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{parent}/importJobs",
    validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsList_589322,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsList_589323,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsCreate_589389 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsCreate_589391(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsCreate_589390(path: JsonNode;
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
  var valid_589392 = path.getOrDefault("parent")
  valid_589392 = validateParameter(valid_589392, JString, required = true,
                                 default = nil)
  if valid_589392 != nil:
    section.add "parent", valid_589392
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
  var valid_589393 = query.getOrDefault("upload_protocol")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "upload_protocol", valid_589393
  var valid_589394 = query.getOrDefault("fields")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "fields", valid_589394
  var valid_589395 = query.getOrDefault("quotaUser")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "quotaUser", valid_589395
  var valid_589396 = query.getOrDefault("alt")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = newJString("json"))
  if valid_589396 != nil:
    section.add "alt", valid_589396
  var valid_589397 = query.getOrDefault("oauth_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "oauth_token", valid_589397
  var valid_589398 = query.getOrDefault("callback")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "callback", valid_589398
  var valid_589399 = query.getOrDefault("access_token")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "access_token", valid_589399
  var valid_589400 = query.getOrDefault("uploadType")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "uploadType", valid_589400
  var valid_589401 = query.getOrDefault("key")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "key", valid_589401
  var valid_589402 = query.getOrDefault("$.xgafv")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("1"))
  if valid_589402 != nil:
    section.add "$.xgafv", valid_589402
  var valid_589403 = query.getOrDefault("prettyPrint")
  valid_589403 = validateParameter(valid_589403, JBool, required = false,
                                 default = newJBool(true))
  if valid_589403 != nil:
    section.add "prettyPrint", valid_589403
  var valid_589404 = query.getOrDefault("keyRingId")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "keyRingId", valid_589404
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

proc call*(call_589406: Call_CloudkmsProjectsLocationsKeyRingsCreate_589389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new KeyRing in a given Project and Location.
  ## 
  let valid = call_589406.validator(path, query, header, formData, body)
  let scheme = call_589406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589406.url(scheme.get, call_589406.host, call_589406.base,
                         call_589406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589406, url, valid)

proc call*(call_589407: Call_CloudkmsProjectsLocationsKeyRingsCreate_589389;
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
  var path_589408 = newJObject()
  var query_589409 = newJObject()
  var body_589410 = newJObject()
  add(query_589409, "upload_protocol", newJString(uploadProtocol))
  add(query_589409, "fields", newJString(fields))
  add(query_589409, "quotaUser", newJString(quotaUser))
  add(query_589409, "alt", newJString(alt))
  add(query_589409, "oauth_token", newJString(oauthToken))
  add(query_589409, "callback", newJString(callback))
  add(query_589409, "access_token", newJString(accessToken))
  add(query_589409, "uploadType", newJString(uploadType))
  add(path_589408, "parent", newJString(parent))
  add(query_589409, "key", newJString(key))
  add(query_589409, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589410 = body
  add(query_589409, "prettyPrint", newJBool(prettyPrint))
  add(query_589409, "keyRingId", newJString(keyRingId))
  result = call_589407.call(path_589408, query_589409, nil, nil, body_589410)

var cloudkmsProjectsLocationsKeyRingsCreate* = Call_CloudkmsProjectsLocationsKeyRingsCreate_589389(
    name: "cloudkmsProjectsLocationsKeyRingsCreate", meth: HttpMethod.HttpPost,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsCreate_589390, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsCreate_589391,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsList_589366 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsList_589368(protocol: Scheme;
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

proc validate_CloudkmsProjectsLocationsKeyRingsList_589367(path: JsonNode;
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
  var valid_589369 = path.getOrDefault("parent")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "parent", valid_589369
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
  var valid_589370 = query.getOrDefault("upload_protocol")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "upload_protocol", valid_589370
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("pageToken")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "pageToken", valid_589372
  var valid_589373 = query.getOrDefault("quotaUser")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "quotaUser", valid_589373
  var valid_589374 = query.getOrDefault("alt")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("json"))
  if valid_589374 != nil:
    section.add "alt", valid_589374
  var valid_589375 = query.getOrDefault("oauth_token")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "oauth_token", valid_589375
  var valid_589376 = query.getOrDefault("callback")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "callback", valid_589376
  var valid_589377 = query.getOrDefault("access_token")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "access_token", valid_589377
  var valid_589378 = query.getOrDefault("uploadType")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "uploadType", valid_589378
  var valid_589379 = query.getOrDefault("orderBy")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "orderBy", valid_589379
  var valid_589380 = query.getOrDefault("key")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "key", valid_589380
  var valid_589381 = query.getOrDefault("$.xgafv")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = newJString("1"))
  if valid_589381 != nil:
    section.add "$.xgafv", valid_589381
  var valid_589382 = query.getOrDefault("pageSize")
  valid_589382 = validateParameter(valid_589382, JInt, required = false, default = nil)
  if valid_589382 != nil:
    section.add "pageSize", valid_589382
  var valid_589383 = query.getOrDefault("prettyPrint")
  valid_589383 = validateParameter(valid_589383, JBool, required = false,
                                 default = newJBool(true))
  if valid_589383 != nil:
    section.add "prettyPrint", valid_589383
  var valid_589384 = query.getOrDefault("filter")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "filter", valid_589384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589385: Call_CloudkmsProjectsLocationsKeyRingsList_589366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists KeyRings.
  ## 
  let valid = call_589385.validator(path, query, header, formData, body)
  let scheme = call_589385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589385.url(scheme.get, call_589385.host, call_589385.base,
                         call_589385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589385, url, valid)

proc call*(call_589386: Call_CloudkmsProjectsLocationsKeyRingsList_589366;
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
  var path_589387 = newJObject()
  var query_589388 = newJObject()
  add(query_589388, "upload_protocol", newJString(uploadProtocol))
  add(query_589388, "fields", newJString(fields))
  add(query_589388, "pageToken", newJString(pageToken))
  add(query_589388, "quotaUser", newJString(quotaUser))
  add(query_589388, "alt", newJString(alt))
  add(query_589388, "oauth_token", newJString(oauthToken))
  add(query_589388, "callback", newJString(callback))
  add(query_589388, "access_token", newJString(accessToken))
  add(query_589388, "uploadType", newJString(uploadType))
  add(path_589387, "parent", newJString(parent))
  add(query_589388, "orderBy", newJString(orderBy))
  add(query_589388, "key", newJString(key))
  add(query_589388, "$.xgafv", newJString(Xgafv))
  add(query_589388, "pageSize", newJInt(pageSize))
  add(query_589388, "prettyPrint", newJBool(prettyPrint))
  add(query_589388, "filter", newJString(filter))
  result = call_589386.call(path_589387, query_589388, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsList* = Call_CloudkmsProjectsLocationsKeyRingsList_589366(
    name: "cloudkmsProjectsLocationsKeyRingsList", meth: HttpMethod.HttpGet,
    host: "cloudkms.googleapis.com", route: "/v1/{parent}/keyRings",
    validator: validate_CloudkmsProjectsLocationsKeyRingsList_589367, base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsList_589368, schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589411 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589413(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589412(
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
  var valid_589414 = path.getOrDefault("resource")
  valid_589414 = validateParameter(valid_589414, JString, required = true,
                                 default = nil)
  if valid_589414 != nil:
    section.add "resource", valid_589414
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589415 = query.getOrDefault("upload_protocol")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "upload_protocol", valid_589415
  var valid_589416 = query.getOrDefault("fields")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "fields", valid_589416
  var valid_589417 = query.getOrDefault("quotaUser")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "quotaUser", valid_589417
  var valid_589418 = query.getOrDefault("alt")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = newJString("json"))
  if valid_589418 != nil:
    section.add "alt", valid_589418
  var valid_589419 = query.getOrDefault("oauth_token")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "oauth_token", valid_589419
  var valid_589420 = query.getOrDefault("callback")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "callback", valid_589420
  var valid_589421 = query.getOrDefault("access_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "access_token", valid_589421
  var valid_589422 = query.getOrDefault("uploadType")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "uploadType", valid_589422
  var valid_589423 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589423 = validateParameter(valid_589423, JInt, required = false, default = nil)
  if valid_589423 != nil:
    section.add "options.requestedPolicyVersion", valid_589423
  var valid_589424 = query.getOrDefault("key")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "key", valid_589424
  var valid_589425 = query.getOrDefault("$.xgafv")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = newJString("1"))
  if valid_589425 != nil:
    section.add "$.xgafv", valid_589425
  var valid_589426 = query.getOrDefault("prettyPrint")
  valid_589426 = validateParameter(valid_589426, JBool, required = false,
                                 default = newJBool(true))
  if valid_589426 != nil:
    section.add "prettyPrint", valid_589426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589427: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589427.validator(path, query, header, formData, body)
  let scheme = call_589427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589427.url(scheme.get, call_589427.host, call_589427.base,
                         call_589427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589427, url, valid)

proc call*(call_589428: Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589411;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy
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
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589429 = newJObject()
  var query_589430 = newJObject()
  add(query_589430, "upload_protocol", newJString(uploadProtocol))
  add(query_589430, "fields", newJString(fields))
  add(query_589430, "quotaUser", newJString(quotaUser))
  add(query_589430, "alt", newJString(alt))
  add(query_589430, "oauth_token", newJString(oauthToken))
  add(query_589430, "callback", newJString(callback))
  add(query_589430, "access_token", newJString(accessToken))
  add(query_589430, "uploadType", newJString(uploadType))
  add(query_589430, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589430, "key", newJString(key))
  add(query_589430, "$.xgafv", newJString(Xgafv))
  add(path_589429, "resource", newJString(resource))
  add(query_589430, "prettyPrint", newJBool(prettyPrint))
  result = call_589428.call(path_589429, query_589430, nil, nil, nil)

var cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589411(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:getIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589412,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsGetIamPolicy_589413,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589431 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589433(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589432(
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
  var valid_589434 = path.getOrDefault("resource")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = nil)
  if valid_589434 != nil:
    section.add "resource", valid_589434
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
  var valid_589435 = query.getOrDefault("upload_protocol")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "upload_protocol", valid_589435
  var valid_589436 = query.getOrDefault("fields")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "fields", valid_589436
  var valid_589437 = query.getOrDefault("quotaUser")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "quotaUser", valid_589437
  var valid_589438 = query.getOrDefault("alt")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = newJString("json"))
  if valid_589438 != nil:
    section.add "alt", valid_589438
  var valid_589439 = query.getOrDefault("oauth_token")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "oauth_token", valid_589439
  var valid_589440 = query.getOrDefault("callback")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "callback", valid_589440
  var valid_589441 = query.getOrDefault("access_token")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "access_token", valid_589441
  var valid_589442 = query.getOrDefault("uploadType")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "uploadType", valid_589442
  var valid_589443 = query.getOrDefault("key")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "key", valid_589443
  var valid_589444 = query.getOrDefault("$.xgafv")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = newJString("1"))
  if valid_589444 != nil:
    section.add "$.xgafv", valid_589444
  var valid_589445 = query.getOrDefault("prettyPrint")
  valid_589445 = validateParameter(valid_589445, JBool, required = false,
                                 default = newJBool(true))
  if valid_589445 != nil:
    section.add "prettyPrint", valid_589445
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

proc call*(call_589447: Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589431;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589447.validator(path, query, header, formData, body)
  let scheme = call_589447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589447.url(scheme.get, call_589447.host, call_589447.base,
                         call_589447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589447, url, valid)

proc call*(call_589448: Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589431;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy
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
  var path_589449 = newJObject()
  var query_589450 = newJObject()
  var body_589451 = newJObject()
  add(query_589450, "upload_protocol", newJString(uploadProtocol))
  add(query_589450, "fields", newJString(fields))
  add(query_589450, "quotaUser", newJString(quotaUser))
  add(query_589450, "alt", newJString(alt))
  add(query_589450, "oauth_token", newJString(oauthToken))
  add(query_589450, "callback", newJString(callback))
  add(query_589450, "access_token", newJString(accessToken))
  add(query_589450, "uploadType", newJString(uploadType))
  add(query_589450, "key", newJString(key))
  add(query_589450, "$.xgafv", newJString(Xgafv))
  add(path_589449, "resource", newJString(resource))
  if body != nil:
    body_589451 = body
  add(query_589450, "prettyPrint", newJBool(prettyPrint))
  result = call_589448.call(path_589449, query_589450, nil, nil, body_589451)

var cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589431(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:setIamPolicy", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589432,
    base: "/", url: url_CloudkmsProjectsLocationsKeyRingsImportJobsSetIamPolicy_589433,
    schemes: {Scheme.Https})
type
  Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589452 = ref object of OpenApiRestCall_588441
proc url_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589454(
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

proc validate_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589453(
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
  var valid_589455 = path.getOrDefault("resource")
  valid_589455 = validateParameter(valid_589455, JString, required = true,
                                 default = nil)
  if valid_589455 != nil:
    section.add "resource", valid_589455
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
  var valid_589456 = query.getOrDefault("upload_protocol")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "upload_protocol", valid_589456
  var valid_589457 = query.getOrDefault("fields")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "fields", valid_589457
  var valid_589458 = query.getOrDefault("quotaUser")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "quotaUser", valid_589458
  var valid_589459 = query.getOrDefault("alt")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = newJString("json"))
  if valid_589459 != nil:
    section.add "alt", valid_589459
  var valid_589460 = query.getOrDefault("oauth_token")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "oauth_token", valid_589460
  var valid_589461 = query.getOrDefault("callback")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "callback", valid_589461
  var valid_589462 = query.getOrDefault("access_token")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "access_token", valid_589462
  var valid_589463 = query.getOrDefault("uploadType")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "uploadType", valid_589463
  var valid_589464 = query.getOrDefault("key")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "key", valid_589464
  var valid_589465 = query.getOrDefault("$.xgafv")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = newJString("1"))
  if valid_589465 != nil:
    section.add "$.xgafv", valid_589465
  var valid_589466 = query.getOrDefault("prettyPrint")
  valid_589466 = validateParameter(valid_589466, JBool, required = false,
                                 default = newJBool(true))
  if valid_589466 != nil:
    section.add "prettyPrint", valid_589466
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

proc call*(call_589468: Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589452;
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
  let valid = call_589468.validator(path, query, header, formData, body)
  let scheme = call_589468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589468.url(scheme.get, call_589468.host, call_589468.base,
                         call_589468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589468, url, valid)

proc call*(call_589469: Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589452;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions
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
  var path_589470 = newJObject()
  var query_589471 = newJObject()
  var body_589472 = newJObject()
  add(query_589471, "upload_protocol", newJString(uploadProtocol))
  add(query_589471, "fields", newJString(fields))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(query_589471, "callback", newJString(callback))
  add(query_589471, "access_token", newJString(accessToken))
  add(query_589471, "uploadType", newJString(uploadType))
  add(query_589471, "key", newJString(key))
  add(query_589471, "$.xgafv", newJString(Xgafv))
  add(path_589470, "resource", newJString(resource))
  if body != nil:
    body_589472 = body
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589469.call(path_589470, query_589471, nil, nil, body_589472)

var cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions* = Call_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589452(
    name: "cloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudkms.googleapis.com",
    route: "/v1/{resource}:testIamPermissions", validator: validate_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589453,
    base: "/",
    url: url_CloudkmsProjectsLocationsKeyRingsImportJobsTestIamPermissions_589454,
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
