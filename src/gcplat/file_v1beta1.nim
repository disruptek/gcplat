
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Filestore
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Cloud Filestore API is used for creating and managing cloud file servers.
## 
## https://cloud.google.com/filestore/
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
  gcpServiceName = "file"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FileProjectsLocationsInstancesGet_588710 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsInstancesGet_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsInstancesGet_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The instance resource name, in the format
  ## projects/{project_id}/locations/{location}/instances/{instance_id}.
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

proc call*(call_588885: Call_FileProjectsLocationsInstancesGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific instance.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_FileProjectsLocationsInstancesGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## fileProjectsLocationsInstancesGet
  ## Gets the details of a specific instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The instance resource name, in the format
  ## projects/{project_id}/locations/{location}/instances/{instance_id}.
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

var fileProjectsLocationsInstancesGet* = Call_FileProjectsLocationsInstancesGet_588710(
    name: "fileProjectsLocationsInstancesGet", meth: HttpMethod.HttpGet,
    host: "file.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FileProjectsLocationsInstancesGet_588711, base: "/",
    url: url_FileProjectsLocationsInstancesGet_588712, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsInstancesPatch_589017 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsInstancesPatch_589019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsInstancesPatch_589018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The resource name of the instance, in the format
  ## projects/{project_id}/locations/{location_id}/instances/{instance_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589020 = path.getOrDefault("name")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "name", valid_589020
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
  ##             : Mask of fields to update.  At least one path must be supplied in this
  ## field.  The elements of the repeated paths field may only include these
  ## fields:
  ## "description"
  ## "file_shares"
  ## "labels"
  section = newJObject()
  var valid_589021 = query.getOrDefault("upload_protocol")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "upload_protocol", valid_589021
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("quotaUser")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "quotaUser", valid_589023
  var valid_589024 = query.getOrDefault("alt")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("json"))
  if valid_589024 != nil:
    section.add "alt", valid_589024
  var valid_589025 = query.getOrDefault("oauth_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "oauth_token", valid_589025
  var valid_589026 = query.getOrDefault("callback")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "callback", valid_589026
  var valid_589027 = query.getOrDefault("access_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "access_token", valid_589027
  var valid_589028 = query.getOrDefault("uploadType")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "uploadType", valid_589028
  var valid_589029 = query.getOrDefault("key")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "key", valid_589029
  var valid_589030 = query.getOrDefault("$.xgafv")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("1"))
  if valid_589030 != nil:
    section.add "$.xgafv", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  var valid_589032 = query.getOrDefault("updateMask")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "updateMask", valid_589032
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

proc call*(call_589034: Call_FileProjectsLocationsInstancesPatch_589017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific instance.
  ## 
  let valid = call_589034.validator(path, query, header, formData, body)
  let scheme = call_589034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589034.url(scheme.get, call_589034.host, call_589034.base,
                         call_589034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589034, url, valid)

proc call*(call_589035: Call_FileProjectsLocationsInstancesPatch_589017;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## fileProjectsLocationsInstancesPatch
  ## Updates the settings of a specific instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The resource name of the instance, in the format
  ## projects/{project_id}/locations/{location_id}/instances/{instance_id}.
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
  ##             : Mask of fields to update.  At least one path must be supplied in this
  ## field.  The elements of the repeated paths field may only include these
  ## fields:
  ## "description"
  ## "file_shares"
  ## "labels"
  var path_589036 = newJObject()
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(path_589036, "name", newJString(name))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  add(query_589037, "updateMask", newJString(updateMask))
  result = call_589035.call(path_589036, query_589037, nil, nil, body_589038)

var fileProjectsLocationsInstancesPatch* = Call_FileProjectsLocationsInstancesPatch_589017(
    name: "fileProjectsLocationsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "file.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FileProjectsLocationsInstancesPatch_589018, base: "/",
    url: url_FileProjectsLocationsInstancesPatch_589019, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsInstancesDelete_588998 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsInstancesDelete_589000(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsInstancesDelete_588999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The instance resource name, in the format
  ## projects/{project_id}/locations/{location}/instances/{instance_id}
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_FileProjectsLocationsInstancesDelete_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an instance.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_FileProjectsLocationsInstancesDelete_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## fileProjectsLocationsInstancesDelete
  ## Deletes an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The instance resource name, in the format
  ## projects/{project_id}/locations/{location}/instances/{instance_id}
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(path_589015, "name", newJString(name))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var fileProjectsLocationsInstancesDelete* = Call_FileProjectsLocationsInstancesDelete_588998(
    name: "fileProjectsLocationsInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "file.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FileProjectsLocationsInstancesDelete_588999, base: "/",
    url: url_FileProjectsLocationsInstancesDelete_589000, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsList_589039 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsList_589041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsList_589040(path: JsonNode; query: JsonNode;
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
  var valid_589042 = path.getOrDefault("name")
  valid_589042 = validateParameter(valid_589042, JString, required = true,
                                 default = nil)
  if valid_589042 != nil:
    section.add "name", valid_589042
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
  var valid_589043 = query.getOrDefault("upload_protocol")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "upload_protocol", valid_589043
  var valid_589044 = query.getOrDefault("fields")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "fields", valid_589044
  var valid_589045 = query.getOrDefault("pageToken")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "pageToken", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("$.xgafv")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("1"))
  if valid_589053 != nil:
    section.add "$.xgafv", valid_589053
  var valid_589054 = query.getOrDefault("pageSize")
  valid_589054 = validateParameter(valid_589054, JInt, required = false, default = nil)
  if valid_589054 != nil:
    section.add "pageSize", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  var valid_589056 = query.getOrDefault("filter")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "filter", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_FileProjectsLocationsList_589039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_FileProjectsLocationsList_589039; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## fileProjectsLocationsList
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
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "pageToken", newJString(pageToken))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(path_589059, "name", newJString(name))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "pageSize", newJInt(pageSize))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  add(query_589060, "filter", newJString(filter))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var fileProjectsLocationsList* = Call_FileProjectsLocationsList_589039(
    name: "fileProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "file.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_FileProjectsLocationsList_589040, base: "/",
    url: url_FileProjectsLocationsList_589041, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsOperationsList_589061 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsOperationsList_589063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsOperationsList_589062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
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
  var valid_589067 = query.getOrDefault("pageToken")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "pageToken", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("pageSize")
  valid_589076 = validateParameter(valid_589076, JInt, required = false, default = nil)
  if valid_589076 != nil:
    section.add "pageSize", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
  var valid_589078 = query.getOrDefault("filter")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "filter", valid_589078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589079: Call_FileProjectsLocationsOperationsList_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_FileProjectsLocationsOperationsList_589061;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## fileProjectsLocationsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "pageToken", newJString(pageToken))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(path_589081, "name", newJString(name))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  add(query_589082, "pageSize", newJInt(pageSize))
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  add(query_589082, "filter", newJString(filter))
  result = call_589080.call(path_589081, query_589082, nil, nil, nil)

var fileProjectsLocationsOperationsList* = Call_FileProjectsLocationsOperationsList_589061(
    name: "fileProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "file.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_FileProjectsLocationsOperationsList_589062, base: "/",
    url: url_FileProjectsLocationsOperationsList_589063, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsOperationsCancel_589083 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsOperationsCancel_589085(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsOperationsCancel_589084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589086 = path.getOrDefault("name")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "name", valid_589086
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
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
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

proc call*(call_589099: Call_FileProjectsLocationsOperationsCancel_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_FileProjectsLocationsOperationsCancel_589083;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fileProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(path_589101, "name", newJString(name))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var fileProjectsLocationsOperationsCancel* = Call_FileProjectsLocationsOperationsCancel_589083(
    name: "fileProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "file.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_FileProjectsLocationsOperationsCancel_589084, base: "/",
    url: url_FileProjectsLocationsOperationsCancel_589085, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsInstancesCreate_589127 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsInstancesCreate_589129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsInstancesCreate_589128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The instance's project and location, in the format
  ## projects/{project_id}/locations/{location}. In Cloud Filestore,
  ## locations map to GCP zones, for example **us-west1-b**.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589130 = path.getOrDefault("parent")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "parent", valid_589130
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
  ##   instanceId: JString
  ##             : The name of the instance to create.
  ## The name must be unique for the specified project and location.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589131 = query.getOrDefault("upload_protocol")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "upload_protocol", valid_589131
  var valid_589132 = query.getOrDefault("fields")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "fields", valid_589132
  var valid_589133 = query.getOrDefault("quotaUser")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "quotaUser", valid_589133
  var valid_589134 = query.getOrDefault("alt")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("json"))
  if valid_589134 != nil:
    section.add "alt", valid_589134
  var valid_589135 = query.getOrDefault("oauth_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "oauth_token", valid_589135
  var valid_589136 = query.getOrDefault("callback")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "callback", valid_589136
  var valid_589137 = query.getOrDefault("access_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "access_token", valid_589137
  var valid_589138 = query.getOrDefault("uploadType")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "uploadType", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("$.xgafv")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("1"))
  if valid_589140 != nil:
    section.add "$.xgafv", valid_589140
  var valid_589141 = query.getOrDefault("instanceId")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "instanceId", valid_589141
  var valid_589142 = query.getOrDefault("prettyPrint")
  valid_589142 = validateParameter(valid_589142, JBool, required = false,
                                 default = newJBool(true))
  if valid_589142 != nil:
    section.add "prettyPrint", valid_589142
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

proc call*(call_589144: Call_FileProjectsLocationsInstancesCreate_589127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an instance.
  ## 
  let valid = call_589144.validator(path, query, header, formData, body)
  let scheme = call_589144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589144.url(scheme.get, call_589144.host, call_589144.base,
                         call_589144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589144, url, valid)

proc call*(call_589145: Call_FileProjectsLocationsInstancesCreate_589127;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; instanceId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fileProjectsLocationsInstancesCreate
  ## Creates an instance.
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
  ##         : The instance's project and location, in the format
  ## projects/{project_id}/locations/{location}. In Cloud Filestore,
  ## locations map to GCP zones, for example **us-west1-b**.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   instanceId: string
  ##             : The name of the instance to create.
  ## The name must be unique for the specified project and location.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589146 = newJObject()
  var query_589147 = newJObject()
  var body_589148 = newJObject()
  add(query_589147, "upload_protocol", newJString(uploadProtocol))
  add(query_589147, "fields", newJString(fields))
  add(query_589147, "quotaUser", newJString(quotaUser))
  add(query_589147, "alt", newJString(alt))
  add(query_589147, "oauth_token", newJString(oauthToken))
  add(query_589147, "callback", newJString(callback))
  add(query_589147, "access_token", newJString(accessToken))
  add(query_589147, "uploadType", newJString(uploadType))
  add(path_589146, "parent", newJString(parent))
  add(query_589147, "key", newJString(key))
  add(query_589147, "$.xgafv", newJString(Xgafv))
  add(query_589147, "instanceId", newJString(instanceId))
  if body != nil:
    body_589148 = body
  add(query_589147, "prettyPrint", newJBool(prettyPrint))
  result = call_589145.call(path_589146, query_589147, nil, nil, body_589148)

var fileProjectsLocationsInstancesCreate* = Call_FileProjectsLocationsInstancesCreate_589127(
    name: "fileProjectsLocationsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "file.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_FileProjectsLocationsInstancesCreate_589128, base: "/",
    url: url_FileProjectsLocationsInstancesCreate_589129, schemes: {Scheme.Https})
type
  Call_FileProjectsLocationsInstancesList_589104 = ref object of OpenApiRestCall_588441
proc url_FileProjectsLocationsInstancesList_589106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileProjectsLocationsInstancesList_589105(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all instances in a project for either a specified location
  ## or for all locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project and location for which to retrieve instance information,
  ## in the format projects/{project_id}/locations/{location}. In Cloud
  ## Filestore, locations map to GCP zones, for example **us-west1-b**. To
  ## retrieve instance information for all locations, use "-" for the {location}
  ## value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589107 = path.getOrDefault("parent")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "parent", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value to use if there are additional
  ## results to retrieve for this list request.
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
  ##          : Sort results. Supported values are "name", "name desc" or "" (unsorted).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : List filter.
  section = newJObject()
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("pageToken")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "pageToken", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("callback")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "callback", valid_589114
  var valid_589115 = query.getOrDefault("access_token")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "access_token", valid_589115
  var valid_589116 = query.getOrDefault("uploadType")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "uploadType", valid_589116
  var valid_589117 = query.getOrDefault("orderBy")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "orderBy", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("pageSize")
  valid_589120 = validateParameter(valid_589120, JInt, required = false, default = nil)
  if valid_589120 != nil:
    section.add "pageSize", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
  var valid_589122 = query.getOrDefault("filter")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "filter", valid_589122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589123: Call_FileProjectsLocationsInstancesList_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all instances in a project for either a specified location
  ## or for all locations.
  ## 
  let valid = call_589123.validator(path, query, header, formData, body)
  let scheme = call_589123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589123.url(scheme.get, call_589123.host, call_589123.base,
                         call_589123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589123, url, valid)

proc call*(call_589124: Call_FileProjectsLocationsInstancesList_589104;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## fileProjectsLocationsInstancesList
  ## Lists all instances in a project for either a specified location
  ## or for all locations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value to use if there are additional
  ## results to retrieve for this list request.
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
  ##         : The project and location for which to retrieve instance information,
  ## in the format projects/{project_id}/locations/{location}. In Cloud
  ## Filestore, locations map to GCP zones, for example **us-west1-b**. To
  ## retrieve instance information for all locations, use "-" for the {location}
  ## value.
  ##   orderBy: string
  ##          : Sort results. Supported values are "name", "name desc" or "" (unsorted).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : List filter.
  var path_589125 = newJObject()
  var query_589126 = newJObject()
  add(query_589126, "upload_protocol", newJString(uploadProtocol))
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "pageToken", newJString(pageToken))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "callback", newJString(callback))
  add(query_589126, "access_token", newJString(accessToken))
  add(query_589126, "uploadType", newJString(uploadType))
  add(path_589125, "parent", newJString(parent))
  add(query_589126, "orderBy", newJString(orderBy))
  add(query_589126, "key", newJString(key))
  add(query_589126, "$.xgafv", newJString(Xgafv))
  add(query_589126, "pageSize", newJInt(pageSize))
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  add(query_589126, "filter", newJString(filter))
  result = call_589124.call(path_589125, query_589126, nil, nil, nil)

var fileProjectsLocationsInstancesList* = Call_FileProjectsLocationsInstancesList_589104(
    name: "fileProjectsLocationsInstancesList", meth: HttpMethod.HttpGet,
    host: "file.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_FileProjectsLocationsInstancesList_589105, base: "/",
    url: url_FileProjectsLocationsInstancesList_589106, schemes: {Scheme.Https})
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
