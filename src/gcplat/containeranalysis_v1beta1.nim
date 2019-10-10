
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Container Analysis
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An implementation of the Grafeas API, which stores, and enables querying and retrieval of critical metadata about all of your software artifacts.
## 
## https://cloud.google.com/container-analysis/api/reference/rest/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "containeranalysis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProjectsScanConfigsUpdate_589007 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsScanConfigsUpdate_589009(protocol: Scheme;
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

proc validate_ContaineranalysisProjectsScanConfigsUpdate_589008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified scan configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
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

proc call*(call_589023: Call_ContaineranalysisProjectsScanConfigsUpdate_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified scan configuration.
  ## 
  let valid = call_589023.validator(path, query, header, formData, body)
  let scheme = call_589023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589023.url(scheme.get, call_589023.host, call_589023.base,
                         call_589023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589023, url, valid)

proc call*(call_589024: Call_ContaineranalysisProjectsScanConfigsUpdate_589007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsScanConfigsUpdate
  ## Updates the specified scan configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
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
  var path_589025 = newJObject()
  var query_589026 = newJObject()
  var body_589027 = newJObject()
  add(query_589026, "upload_protocol", newJString(uploadProtocol))
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(path_589025, "name", newJString(name))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "callback", newJString(callback))
  add(query_589026, "access_token", newJString(accessToken))
  add(query_589026, "uploadType", newJString(uploadType))
  add(query_589026, "key", newJString(key))
  add(query_589026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589027 = body
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  result = call_589024.call(path_589025, query_589026, nil, nil, body_589027)

var containeranalysisProjectsScanConfigsUpdate* = Call_ContaineranalysisProjectsScanConfigsUpdate_589007(
    name: "containeranalysisProjectsScanConfigsUpdate", meth: HttpMethod.HttpPut,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsUpdate_589008,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsUpdate_589009,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsGet_588719 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsScanConfigsGet_588721(protocol: Scheme;
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

proc validate_ContaineranalysisProjectsScanConfigsGet_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified scan configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_ContaineranalysisProjectsScanConfigsGet_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified scan configuration.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_ContaineranalysisProjectsScanConfigsGet_588719;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsScanConfigsGet
  ## Gets the specified scan configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the scan configuration in the form of
  ## `projects/[PROJECT_ID]/scanConfigs/[SCAN_CONFIG_ID]`.
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(path_588966, "name", newJString(name))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var containeranalysisProjectsScanConfigsGet* = Call_ContaineranalysisProjectsScanConfigsGet_588719(
    name: "containeranalysisProjectsScanConfigsGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsScanConfigsGet_588720, base: "/",
    url: url_ContaineranalysisProjectsScanConfigsGet_588721,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesPatch_589047 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesPatch_589049(protocol: Scheme; host: string;
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

proc validate_ContaineranalysisProjectsNotesPatch_589048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589050 = path.getOrDefault("name")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "name", valid_589050
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
  ##             : The fields to update.
  section = newJObject()
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("callback")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "callback", valid_589056
  var valid_589057 = query.getOrDefault("access_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "access_token", valid_589057
  var valid_589058 = query.getOrDefault("uploadType")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "uploadType", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("$.xgafv")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("1"))
  if valid_589060 != nil:
    section.add "$.xgafv", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
  var valid_589062 = query.getOrDefault("updateMask")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "updateMask", valid_589062
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

proc call*(call_589064: Call_ContaineranalysisProjectsNotesPatch_589047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified note.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_ContaineranalysisProjectsNotesPatch_589047;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## containeranalysisProjectsNotesPatch
  ## Updates the specified note.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
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
  ##             : The fields to update.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  var body_589068 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(path_589066, "name", newJString(name))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(query_589067, "key", newJString(key))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589068 = body
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  add(query_589067, "updateMask", newJString(updateMask))
  result = call_589065.call(path_589066, query_589067, nil, nil, body_589068)

var containeranalysisProjectsNotesPatch* = Call_ContaineranalysisProjectsNotesPatch_589047(
    name: "containeranalysisProjectsNotesPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsNotesPatch_589048, base: "/",
    url: url_ContaineranalysisProjectsNotesPatch_589049, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesDelete_589028 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesDelete_589030(protocol: Scheme;
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

proc validate_ContaineranalysisProjectsNotesDelete_589029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589031 = path.getOrDefault("name")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "name", valid_589031
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
  var valid_589032 = query.getOrDefault("upload_protocol")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "upload_protocol", valid_589032
  var valid_589033 = query.getOrDefault("fields")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "fields", valid_589033
  var valid_589034 = query.getOrDefault("quotaUser")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "quotaUser", valid_589034
  var valid_589035 = query.getOrDefault("alt")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("json"))
  if valid_589035 != nil:
    section.add "alt", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("callback")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "callback", valid_589037
  var valid_589038 = query.getOrDefault("access_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "access_token", valid_589038
  var valid_589039 = query.getOrDefault("uploadType")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "uploadType", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("$.xgafv")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("1"))
  if valid_589041 != nil:
    section.add "$.xgafv", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_ContaineranalysisProjectsNotesDelete_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified note.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_ContaineranalysisProjectsNotesDelete_589028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesDelete
  ## Deletes the specified note.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  add(query_589046, "upload_protocol", newJString(uploadProtocol))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(path_589045, "name", newJString(name))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "callback", newJString(callback))
  add(query_589046, "access_token", newJString(accessToken))
  add(query_589046, "uploadType", newJString(uploadType))
  add(query_589046, "key", newJString(key))
  add(query_589046, "$.xgafv", newJString(Xgafv))
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(path_589045, query_589046, nil, nil, nil)

var containeranalysisProjectsNotesDelete* = Call_ContaineranalysisProjectsNotesDelete_589028(
    name: "containeranalysisProjectsNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_ContaineranalysisProjectsNotesDelete_589029, base: "/",
    url: url_ContaineranalysisProjectsNotesDelete_589030, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetNotes_589069 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesGetNotes_589071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetNotes_589070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the occurrence in the form of
  ## `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589072 = path.getOrDefault("name")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "name", valid_589072
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
  var valid_589073 = query.getOrDefault("upload_protocol")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "upload_protocol", valid_589073
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("$.xgafv")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("1"))
  if valid_589082 != nil:
    section.add "$.xgafv", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589084: Call_ContaineranalysisProjectsOccurrencesGetNotes_589069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_ContaineranalysisProjectsOccurrencesGetNotes_589069;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesGetNotes
  ## Gets the note attached to the specified occurrence. Consumer projects can
  ## use this method to get a note that belongs to a provider project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the occurrence in the form of
  ## `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]`.
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
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  add(query_589087, "upload_protocol", newJString(uploadProtocol))
  add(query_589087, "fields", newJString(fields))
  add(query_589087, "quotaUser", newJString(quotaUser))
  add(path_589086, "name", newJString(name))
  add(query_589087, "alt", newJString(alt))
  add(query_589087, "oauth_token", newJString(oauthToken))
  add(query_589087, "callback", newJString(callback))
  add(query_589087, "access_token", newJString(accessToken))
  add(query_589087, "uploadType", newJString(uploadType))
  add(query_589087, "key", newJString(key))
  add(query_589087, "$.xgafv", newJString(Xgafv))
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetNotes* = Call_ContaineranalysisProjectsOccurrencesGetNotes_589069(
    name: "containeranalysisProjectsOccurrencesGetNotes",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{name}/notes",
    validator: validate_ContaineranalysisProjectsOccurrencesGetNotes_589070,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesGetNotes_589071,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesOccurrencesList_589088 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesOccurrencesList_589090(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesOccurrencesList_589089(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note to list occurrences for in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589091 = path.getOrDefault("name")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "name", valid_589091
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589092 = query.getOrDefault("upload_protocol")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "upload_protocol", valid_589092
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("pageToken")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "pageToken", valid_589094
  var valid_589095 = query.getOrDefault("quotaUser")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "quotaUser", valid_589095
  var valid_589096 = query.getOrDefault("alt")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("json"))
  if valid_589096 != nil:
    section.add "alt", valid_589096
  var valid_589097 = query.getOrDefault("oauth_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "oauth_token", valid_589097
  var valid_589098 = query.getOrDefault("callback")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "callback", valid_589098
  var valid_589099 = query.getOrDefault("access_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "access_token", valid_589099
  var valid_589100 = query.getOrDefault("uploadType")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "uploadType", valid_589100
  var valid_589101 = query.getOrDefault("key")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "key", valid_589101
  var valid_589102 = query.getOrDefault("$.xgafv")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("1"))
  if valid_589102 != nil:
    section.add "$.xgafv", valid_589102
  var valid_589103 = query.getOrDefault("pageSize")
  valid_589103 = validateParameter(valid_589103, JInt, required = false, default = nil)
  if valid_589103 != nil:
    section.add "pageSize", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
  var valid_589105 = query.getOrDefault("filter")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "filter", valid_589105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589106: Call_ContaineranalysisProjectsNotesOccurrencesList_589088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ## 
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_ContaineranalysisProjectsNotesOccurrencesList_589088;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesOccurrencesList
  ## Lists occurrences referencing the specified note. Provider projects can use
  ## this method to get all occurrences across consumer projects referencing the
  ## specified note.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the note to list occurrences for in the form of
  ## `projects/[PROVIDER_ID]/notes/[NOTE_ID]`.
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
  ##           : Number of occurrences to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589108 = newJObject()
  var query_589109 = newJObject()
  add(query_589109, "upload_protocol", newJString(uploadProtocol))
  add(query_589109, "fields", newJString(fields))
  add(query_589109, "pageToken", newJString(pageToken))
  add(query_589109, "quotaUser", newJString(quotaUser))
  add(path_589108, "name", newJString(name))
  add(query_589109, "alt", newJString(alt))
  add(query_589109, "oauth_token", newJString(oauthToken))
  add(query_589109, "callback", newJString(callback))
  add(query_589109, "access_token", newJString(accessToken))
  add(query_589109, "uploadType", newJString(uploadType))
  add(query_589109, "key", newJString(key))
  add(query_589109, "$.xgafv", newJString(Xgafv))
  add(query_589109, "pageSize", newJInt(pageSize))
  add(query_589109, "prettyPrint", newJBool(prettyPrint))
  add(query_589109, "filter", newJString(filter))
  result = call_589107.call(path_589108, query_589109, nil, nil, nil)

var containeranalysisProjectsNotesOccurrencesList* = Call_ContaineranalysisProjectsNotesOccurrencesList_589088(
    name: "containeranalysisProjectsNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{name}/occurrences",
    validator: validate_ContaineranalysisProjectsNotesOccurrencesList_589089,
    base: "/", url: url_ContaineranalysisProjectsNotesOccurrencesList_589090,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_589132 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesCreate_589134(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_589133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new note.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the note is to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589135 = path.getOrDefault("parent")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "parent", valid_589135
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
  ##   noteId: JString
  ##         : The ID to use for this note.
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
  var valid_589136 = query.getOrDefault("upload_protocol")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "upload_protocol", valid_589136
  var valid_589137 = query.getOrDefault("fields")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "fields", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("noteId")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "noteId", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("callback")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "callback", valid_589142
  var valid_589143 = query.getOrDefault("access_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "access_token", valid_589143
  var valid_589144 = query.getOrDefault("uploadType")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "uploadType", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("$.xgafv")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("1"))
  if valid_589146 != nil:
    section.add "$.xgafv", valid_589146
  var valid_589147 = query.getOrDefault("prettyPrint")
  valid_589147 = validateParameter(valid_589147, JBool, required = false,
                                 default = newJBool(true))
  if valid_589147 != nil:
    section.add "prettyPrint", valid_589147
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

proc call*(call_589149: Call_ContaineranalysisProjectsNotesCreate_589132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new note.
  ## 
  let valid = call_589149.validator(path, query, header, formData, body)
  let scheme = call_589149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589149.url(scheme.get, call_589149.host, call_589149.base,
                         call_589149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589149, url, valid)

proc call*(call_589150: Call_ContaineranalysisProjectsNotesCreate_589132;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; noteId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new note.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the note is to be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589151 = newJObject()
  var query_589152 = newJObject()
  var body_589153 = newJObject()
  add(query_589152, "upload_protocol", newJString(uploadProtocol))
  add(query_589152, "fields", newJString(fields))
  add(query_589152, "quotaUser", newJString(quotaUser))
  add(query_589152, "alt", newJString(alt))
  add(query_589152, "noteId", newJString(noteId))
  add(query_589152, "oauth_token", newJString(oauthToken))
  add(query_589152, "callback", newJString(callback))
  add(query_589152, "access_token", newJString(accessToken))
  add(query_589152, "uploadType", newJString(uploadType))
  add(path_589151, "parent", newJString(parent))
  add(query_589152, "key", newJString(key))
  add(query_589152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589153 = body
  add(query_589152, "prettyPrint", newJBool(prettyPrint))
  result = call_589150.call(path_589151, query_589152, nil, nil, body_589153)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_589132(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_589133, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_589134, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_589110 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesList_589112(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_589111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists notes for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list notes for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589113 = path.getOrDefault("parent")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "parent", valid_589113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of notes to return in the list. Must be positive. Max allowed page
  ## size is 1000. If not specified, page size defaults to 20.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589114 = query.getOrDefault("upload_protocol")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "upload_protocol", valid_589114
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("pageToken")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "pageToken", valid_589116
  var valid_589117 = query.getOrDefault("quotaUser")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "quotaUser", valid_589117
  var valid_589118 = query.getOrDefault("alt")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("json"))
  if valid_589118 != nil:
    section.add "alt", valid_589118
  var valid_589119 = query.getOrDefault("oauth_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "oauth_token", valid_589119
  var valid_589120 = query.getOrDefault("callback")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "callback", valid_589120
  var valid_589121 = query.getOrDefault("access_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "access_token", valid_589121
  var valid_589122 = query.getOrDefault("uploadType")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "uploadType", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("$.xgafv")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("1"))
  if valid_589124 != nil:
    section.add "$.xgafv", valid_589124
  var valid_589125 = query.getOrDefault("pageSize")
  valid_589125 = validateParameter(valid_589125, JInt, required = false, default = nil)
  if valid_589125 != nil:
    section.add "pageSize", valid_589125
  var valid_589126 = query.getOrDefault("prettyPrint")
  valid_589126 = validateParameter(valid_589126, JBool, required = false,
                                 default = newJBool(true))
  if valid_589126 != nil:
    section.add "prettyPrint", valid_589126
  var valid_589127 = query.getOrDefault("filter")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "filter", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_ContaineranalysisProjectsNotesList_589110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists notes for the specified project.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_ContaineranalysisProjectsNotesList_589110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists notes for the specified project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : The name of the project to list notes for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list. Must be positive. Max allowed page
  ## size is 1000. If not specified, page size defaults to 20.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  add(query_589131, "upload_protocol", newJString(uploadProtocol))
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "pageToken", newJString(pageToken))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "callback", newJString(callback))
  add(query_589131, "access_token", newJString(accessToken))
  add(query_589131, "uploadType", newJString(uploadType))
  add(path_589130, "parent", newJString(parent))
  add(query_589131, "key", newJString(key))
  add(query_589131, "$.xgafv", newJString(Xgafv))
  add(query_589131, "pageSize", newJInt(pageSize))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  add(query_589131, "filter", newJString(filter))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_589110(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1beta1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_589111, base: "/",
    url: url_ContaineranalysisProjectsNotesList_589112, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesBatchCreate_589154 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesBatchCreate_589156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesBatchCreate_589155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates new notes in batch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the notes are to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589157 = path.getOrDefault("parent")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "parent", valid_589157
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
  var valid_589158 = query.getOrDefault("upload_protocol")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "upload_protocol", valid_589158
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("callback")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "callback", valid_589163
  var valid_589164 = query.getOrDefault("access_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "access_token", valid_589164
  var valid_589165 = query.getOrDefault("uploadType")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "uploadType", valid_589165
  var valid_589166 = query.getOrDefault("key")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "key", valid_589166
  var valid_589167 = query.getOrDefault("$.xgafv")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("1"))
  if valid_589167 != nil:
    section.add "$.xgafv", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
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

proc call*(call_589170: Call_ContaineranalysisProjectsNotesBatchCreate_589154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new notes in batch.
  ## 
  let valid = call_589170.validator(path, query, header, formData, body)
  let scheme = call_589170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589170.url(scheme.get, call_589170.host, call_589170.base,
                         call_589170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589170, url, valid)

proc call*(call_589171: Call_ContaineranalysisProjectsNotesBatchCreate_589154;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesBatchCreate
  ## Creates new notes in batch.
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
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the notes are to be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589172 = newJObject()
  var query_589173 = newJObject()
  var body_589174 = newJObject()
  add(query_589173, "upload_protocol", newJString(uploadProtocol))
  add(query_589173, "fields", newJString(fields))
  add(query_589173, "quotaUser", newJString(quotaUser))
  add(query_589173, "alt", newJString(alt))
  add(query_589173, "oauth_token", newJString(oauthToken))
  add(query_589173, "callback", newJString(callback))
  add(query_589173, "access_token", newJString(accessToken))
  add(query_589173, "uploadType", newJString(uploadType))
  add(path_589172, "parent", newJString(parent))
  add(query_589173, "key", newJString(key))
  add(query_589173, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589174 = body
  add(query_589173, "prettyPrint", newJBool(prettyPrint))
  result = call_589171.call(path_589172, query_589173, nil, nil, body_589174)

var containeranalysisProjectsNotesBatchCreate* = Call_ContaineranalysisProjectsNotesBatchCreate_589154(
    name: "containeranalysisProjectsNotesBatchCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/notes:batchCreate",
    validator: validate_ContaineranalysisProjectsNotesBatchCreate_589155,
    base: "/", url: url_ContaineranalysisProjectsNotesBatchCreate_589156,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_589197 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesCreate_589199(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_589198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new occurrence.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrence is to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589200 = path.getOrDefault("parent")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "parent", valid_589200
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
  var valid_589201 = query.getOrDefault("upload_protocol")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "upload_protocol", valid_589201
  var valid_589202 = query.getOrDefault("fields")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "fields", valid_589202
  var valid_589203 = query.getOrDefault("quotaUser")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "quotaUser", valid_589203
  var valid_589204 = query.getOrDefault("alt")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = newJString("json"))
  if valid_589204 != nil:
    section.add "alt", valid_589204
  var valid_589205 = query.getOrDefault("oauth_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "oauth_token", valid_589205
  var valid_589206 = query.getOrDefault("callback")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "callback", valid_589206
  var valid_589207 = query.getOrDefault("access_token")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "access_token", valid_589207
  var valid_589208 = query.getOrDefault("uploadType")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "uploadType", valid_589208
  var valid_589209 = query.getOrDefault("key")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "key", valid_589209
  var valid_589210 = query.getOrDefault("$.xgafv")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("1"))
  if valid_589210 != nil:
    section.add "$.xgafv", valid_589210
  var valid_589211 = query.getOrDefault("prettyPrint")
  valid_589211 = validateParameter(valid_589211, JBool, required = false,
                                 default = newJBool(true))
  if valid_589211 != nil:
    section.add "prettyPrint", valid_589211
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

proc call*(call_589213: Call_ContaineranalysisProjectsOccurrencesCreate_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new occurrence.
  ## 
  let valid = call_589213.validator(path, query, header, formData, body)
  let scheme = call_589213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589213.url(scheme.get, call_589213.host, call_589213.base,
                         call_589213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589213, url, valid)

proc call*(call_589214: Call_ContaineranalysisProjectsOccurrencesCreate_589197;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new occurrence.
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
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrence is to be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589215 = newJObject()
  var query_589216 = newJObject()
  var body_589217 = newJObject()
  add(query_589216, "upload_protocol", newJString(uploadProtocol))
  add(query_589216, "fields", newJString(fields))
  add(query_589216, "quotaUser", newJString(quotaUser))
  add(query_589216, "alt", newJString(alt))
  add(query_589216, "oauth_token", newJString(oauthToken))
  add(query_589216, "callback", newJString(callback))
  add(query_589216, "access_token", newJString(accessToken))
  add(query_589216, "uploadType", newJString(uploadType))
  add(path_589215, "parent", newJString(parent))
  add(query_589216, "key", newJString(key))
  add(query_589216, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589217 = body
  add(query_589216, "prettyPrint", newJBool(prettyPrint))
  result = call_589214.call(path_589215, query_589216, nil, nil, body_589217)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_589197(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_589198,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_589199,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_589175 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesList_589177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_589176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists occurrences for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list occurrences for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589178 = path.getOrDefault("parent")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "parent", valid_589178
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : Number of occurrences to return in the list. Must be positive. Max allowed
  ## page size is 1000. If not specified, page size defaults to 20.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589179 = query.getOrDefault("upload_protocol")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "upload_protocol", valid_589179
  var valid_589180 = query.getOrDefault("fields")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "fields", valid_589180
  var valid_589181 = query.getOrDefault("pageToken")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "pageToken", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("callback")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "callback", valid_589185
  var valid_589186 = query.getOrDefault("access_token")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "access_token", valid_589186
  var valid_589187 = query.getOrDefault("uploadType")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "uploadType", valid_589187
  var valid_589188 = query.getOrDefault("key")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "key", valid_589188
  var valid_589189 = query.getOrDefault("$.xgafv")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("1"))
  if valid_589189 != nil:
    section.add "$.xgafv", valid_589189
  var valid_589190 = query.getOrDefault("pageSize")
  valid_589190 = validateParameter(valid_589190, JInt, required = false, default = nil)
  if valid_589190 != nil:
    section.add "pageSize", valid_589190
  var valid_589191 = query.getOrDefault("prettyPrint")
  valid_589191 = validateParameter(valid_589191, JBool, required = false,
                                 default = newJBool(true))
  if valid_589191 != nil:
    section.add "prettyPrint", valid_589191
  var valid_589192 = query.getOrDefault("filter")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "filter", valid_589192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589193: Call_ContaineranalysisProjectsOccurrencesList_589175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists occurrences for the specified project.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_ContaineranalysisProjectsOccurrencesList_589175;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists occurrences for the specified project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : The name of the project to list occurrences for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list. Must be positive. Max allowed
  ## page size is 1000. If not specified, page size defaults to 20.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  add(query_589196, "upload_protocol", newJString(uploadProtocol))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "pageToken", newJString(pageToken))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "callback", newJString(callback))
  add(query_589196, "access_token", newJString(accessToken))
  add(query_589196, "uploadType", newJString(uploadType))
  add(path_589195, "parent", newJString(parent))
  add(query_589196, "key", newJString(key))
  add(query_589196, "$.xgafv", newJString(Xgafv))
  add(query_589196, "pageSize", newJInt(pageSize))
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  add(query_589196, "filter", newJString(filter))
  result = call_589194.call(path_589195, query_589196, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_589175(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_589176,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_589177,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesBatchCreate_589218 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesBatchCreate_589220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesBatchCreate_589219(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates new occurrences in batch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrences are to be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589221 = path.getOrDefault("parent")
  valid_589221 = validateParameter(valid_589221, JString, required = true,
                                 default = nil)
  if valid_589221 != nil:
    section.add "parent", valid_589221
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
  var valid_589222 = query.getOrDefault("upload_protocol")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "upload_protocol", valid_589222
  var valid_589223 = query.getOrDefault("fields")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "fields", valid_589223
  var valid_589224 = query.getOrDefault("quotaUser")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "quotaUser", valid_589224
  var valid_589225 = query.getOrDefault("alt")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("json"))
  if valid_589225 != nil:
    section.add "alt", valid_589225
  var valid_589226 = query.getOrDefault("oauth_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "oauth_token", valid_589226
  var valid_589227 = query.getOrDefault("callback")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "callback", valid_589227
  var valid_589228 = query.getOrDefault("access_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "access_token", valid_589228
  var valid_589229 = query.getOrDefault("uploadType")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "uploadType", valid_589229
  var valid_589230 = query.getOrDefault("key")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "key", valid_589230
  var valid_589231 = query.getOrDefault("$.xgafv")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("1"))
  if valid_589231 != nil:
    section.add "$.xgafv", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
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

proc call*(call_589234: Call_ContaineranalysisProjectsOccurrencesBatchCreate_589218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates new occurrences in batch.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_ContaineranalysisProjectsOccurrencesBatchCreate_589218;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsOccurrencesBatchCreate
  ## Creates new occurrences in batch.
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
  ##         : The name of the project in the form of `projects/[PROJECT_ID]`, under which
  ## the occurrences are to be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589236 = newJObject()
  var query_589237 = newJObject()
  var body_589238 = newJObject()
  add(query_589237, "upload_protocol", newJString(uploadProtocol))
  add(query_589237, "fields", newJString(fields))
  add(query_589237, "quotaUser", newJString(quotaUser))
  add(query_589237, "alt", newJString(alt))
  add(query_589237, "oauth_token", newJString(oauthToken))
  add(query_589237, "callback", newJString(callback))
  add(query_589237, "access_token", newJString(accessToken))
  add(query_589237, "uploadType", newJString(uploadType))
  add(path_589236, "parent", newJString(parent))
  add(query_589237, "key", newJString(key))
  add(query_589237, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589238 = body
  add(query_589237, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(path_589236, query_589237, nil, nil, body_589238)

var containeranalysisProjectsOccurrencesBatchCreate* = Call_ContaineranalysisProjectsOccurrencesBatchCreate_589218(
    name: "containeranalysisProjectsOccurrencesBatchCreate",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences:batchCreate",
    validator: validate_ContaineranalysisProjectsOccurrencesBatchCreate_589219,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesBatchCreate_589220,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589239 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589241(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589240(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to get a vulnerability summary for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589242 = path.getOrDefault("parent")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = nil)
  if valid_589242 != nil:
    section.add "parent", valid_589242
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
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589243 = query.getOrDefault("upload_protocol")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "upload_protocol", valid_589243
  var valid_589244 = query.getOrDefault("fields")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "fields", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("alt")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("json"))
  if valid_589246 != nil:
    section.add "alt", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("callback")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "callback", valid_589248
  var valid_589249 = query.getOrDefault("access_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "access_token", valid_589249
  var valid_589250 = query.getOrDefault("uploadType")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "uploadType", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
  var valid_589254 = query.getOrDefault("filter")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "filter", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589239;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##         : The name of the project to get a vulnerability summary for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "upload_protocol", newJString(uploadProtocol))
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "callback", newJString(callback))
  add(query_589258, "access_token", newJString(accessToken))
  add(query_589258, "uploadType", newJString(uploadType))
  add(path_589257, "parent", newJString(parent))
  add(query_589258, "key", newJString(key))
  add(query_589258, "$.xgafv", newJString(Xgafv))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  add(query_589258, "filter", newJString(filter))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589239(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589240,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_589241,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_589259 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsScanConfigsList_589261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_589260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for the specified project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the project to list scan configurations for in the form of
  ## `projects/[PROJECT_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589262 = path.getOrDefault("parent")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "parent", valid_589262
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##           : The number of scan configs to return in the list.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter expression.
  section = newJObject()
  var valid_589263 = query.getOrDefault("upload_protocol")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "upload_protocol", valid_589263
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("pageToken")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "pageToken", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("callback")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "callback", valid_589269
  var valid_589270 = query.getOrDefault("access_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "access_token", valid_589270
  var valid_589271 = query.getOrDefault("uploadType")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "uploadType", valid_589271
  var valid_589272 = query.getOrDefault("key")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "key", valid_589272
  var valid_589273 = query.getOrDefault("$.xgafv")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("1"))
  if valid_589273 != nil:
    section.add "$.xgafv", valid_589273
  var valid_589274 = query.getOrDefault("pageSize")
  valid_589274 = validateParameter(valid_589274, JInt, required = false, default = nil)
  if valid_589274 != nil:
    section.add "pageSize", valid_589274
  var valid_589275 = query.getOrDefault("prettyPrint")
  valid_589275 = validateParameter(valid_589275, JBool, required = false,
                                 default = newJBool(true))
  if valid_589275 != nil:
    section.add "prettyPrint", valid_589275
  var valid_589276 = query.getOrDefault("filter")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "filter", valid_589276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589277: Call_ContaineranalysisProjectsScanConfigsList_589259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for the specified project.
  ## 
  let valid = call_589277.validator(path, query, header, formData, body)
  let scheme = call_589277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589277.url(scheme.get, call_589277.host, call_589277.base,
                         call_589277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589277, url, valid)

proc call*(call_589278: Call_ContaineranalysisProjectsScanConfigsList_589259;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for the specified project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
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
  ##         : The name of the project to list scan configurations for in the form of
  ## `projects/[PROJECT_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of scan configs to return in the list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter expression.
  var path_589279 = newJObject()
  var query_589280 = newJObject()
  add(query_589280, "upload_protocol", newJString(uploadProtocol))
  add(query_589280, "fields", newJString(fields))
  add(query_589280, "pageToken", newJString(pageToken))
  add(query_589280, "quotaUser", newJString(quotaUser))
  add(query_589280, "alt", newJString(alt))
  add(query_589280, "oauth_token", newJString(oauthToken))
  add(query_589280, "callback", newJString(callback))
  add(query_589280, "access_token", newJString(accessToken))
  add(query_589280, "uploadType", newJString(uploadType))
  add(path_589279, "parent", newJString(parent))
  add(query_589280, "key", newJString(key))
  add(query_589280, "$.xgafv", newJString(Xgafv))
  add(query_589280, "pageSize", newJInt(pageSize))
  add(query_589280, "prettyPrint", newJBool(prettyPrint))
  add(query_589280, "filter", newJString(filter))
  result = call_589278.call(path_589279, query_589280, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_589259(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_589260,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_589261,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesGetIamPolicy_589281 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesGetIamPolicy_589283(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesGetIamPolicy_589282(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589284 = path.getOrDefault("resource")
  valid_589284 = validateParameter(valid_589284, JString, required = true,
                                 default = nil)
  if valid_589284 != nil:
    section.add "resource", valid_589284
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
  var valid_589285 = query.getOrDefault("upload_protocol")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "upload_protocol", valid_589285
  var valid_589286 = query.getOrDefault("fields")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "fields", valid_589286
  var valid_589287 = query.getOrDefault("quotaUser")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "quotaUser", valid_589287
  var valid_589288 = query.getOrDefault("alt")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("json"))
  if valid_589288 != nil:
    section.add "alt", valid_589288
  var valid_589289 = query.getOrDefault("oauth_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "oauth_token", valid_589289
  var valid_589290 = query.getOrDefault("callback")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "callback", valid_589290
  var valid_589291 = query.getOrDefault("access_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "access_token", valid_589291
  var valid_589292 = query.getOrDefault("uploadType")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "uploadType", valid_589292
  var valid_589293 = query.getOrDefault("key")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "key", valid_589293
  var valid_589294 = query.getOrDefault("$.xgafv")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("1"))
  if valid_589294 != nil:
    section.add "$.xgafv", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
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

proc call*(call_589297: Call_ContaineranalysisProjectsNotesGetIamPolicy_589281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_589297.validator(path, query, header, formData, body)
  let scheme = call_589297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589297.url(scheme.get, call_589297.host, call_589297.base,
                         call_589297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589297, url, valid)

proc call*(call_589298: Call_ContaineranalysisProjectsNotesGetIamPolicy_589281;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesGetIamPolicy
  ## Gets the access control policy for a note or an occurrence resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589299 = newJObject()
  var query_589300 = newJObject()
  var body_589301 = newJObject()
  add(query_589300, "upload_protocol", newJString(uploadProtocol))
  add(query_589300, "fields", newJString(fields))
  add(query_589300, "quotaUser", newJString(quotaUser))
  add(query_589300, "alt", newJString(alt))
  add(query_589300, "oauth_token", newJString(oauthToken))
  add(query_589300, "callback", newJString(callback))
  add(query_589300, "access_token", newJString(accessToken))
  add(query_589300, "uploadType", newJString(uploadType))
  add(query_589300, "key", newJString(key))
  add(query_589300, "$.xgafv", newJString(Xgafv))
  add(path_589299, "resource", newJString(resource))
  if body != nil:
    body_589301 = body
  add(query_589300, "prettyPrint", newJBool(prettyPrint))
  result = call_589298.call(path_589299, query_589300, nil, nil, body_589301)

var containeranalysisProjectsNotesGetIamPolicy* = Call_ContaineranalysisProjectsNotesGetIamPolicy_589281(
    name: "containeranalysisProjectsNotesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesGetIamPolicy_589282,
    base: "/", url: url_ContaineranalysisProjectsNotesGetIamPolicy_589283,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesSetIamPolicy_589302 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesSetIamPolicy_589304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesSetIamPolicy_589303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589305 = path.getOrDefault("resource")
  valid_589305 = validateParameter(valid_589305, JString, required = true,
                                 default = nil)
  if valid_589305 != nil:
    section.add "resource", valid_589305
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
  var valid_589306 = query.getOrDefault("upload_protocol")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "upload_protocol", valid_589306
  var valid_589307 = query.getOrDefault("fields")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "fields", valid_589307
  var valid_589308 = query.getOrDefault("quotaUser")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "quotaUser", valid_589308
  var valid_589309 = query.getOrDefault("alt")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = newJString("json"))
  if valid_589309 != nil:
    section.add "alt", valid_589309
  var valid_589310 = query.getOrDefault("oauth_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "oauth_token", valid_589310
  var valid_589311 = query.getOrDefault("callback")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "callback", valid_589311
  var valid_589312 = query.getOrDefault("access_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "access_token", valid_589312
  var valid_589313 = query.getOrDefault("uploadType")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "uploadType", valid_589313
  var valid_589314 = query.getOrDefault("key")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "key", valid_589314
  var valid_589315 = query.getOrDefault("$.xgafv")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = newJString("1"))
  if valid_589315 != nil:
    section.add "$.xgafv", valid_589315
  var valid_589316 = query.getOrDefault("prettyPrint")
  valid_589316 = validateParameter(valid_589316, JBool, required = false,
                                 default = newJBool(true))
  if valid_589316 != nil:
    section.add "prettyPrint", valid_589316
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

proc call*(call_589318: Call_ContaineranalysisProjectsNotesSetIamPolicy_589302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_ContaineranalysisProjectsNotesSetIamPolicy_589302;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesSetIamPolicy
  ## Sets the access control policy on the specified note or occurrence.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or an occurrence, respectively.
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  var body_589322 = newJObject()
  add(query_589321, "upload_protocol", newJString(uploadProtocol))
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "alt", newJString(alt))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(query_589321, "callback", newJString(callback))
  add(query_589321, "access_token", newJString(accessToken))
  add(query_589321, "uploadType", newJString(uploadType))
  add(query_589321, "key", newJString(key))
  add(query_589321, "$.xgafv", newJString(Xgafv))
  add(path_589320, "resource", newJString(resource))
  if body != nil:
    body_589322 = body
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  result = call_589319.call(path_589320, query_589321, nil, nil, body_589322)

var containeranalysisProjectsNotesSetIamPolicy* = Call_ContaineranalysisProjectsNotesSetIamPolicy_589302(
    name: "containeranalysisProjectsNotesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProjectsNotesSetIamPolicy_589303,
    base: "/", url: url_ContaineranalysisProjectsNotesSetIamPolicy_589304,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesTestIamPermissions_589323 = ref object of OpenApiRestCall_588450
proc url_ContaineranalysisProjectsNotesTestIamPermissions_589325(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesTestIamPermissions_589324(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589326 = path.getOrDefault("resource")
  valid_589326 = validateParameter(valid_589326, JString, required = true,
                                 default = nil)
  if valid_589326 != nil:
    section.add "resource", valid_589326
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
  var valid_589327 = query.getOrDefault("upload_protocol")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "upload_protocol", valid_589327
  var valid_589328 = query.getOrDefault("fields")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "fields", valid_589328
  var valid_589329 = query.getOrDefault("quotaUser")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "quotaUser", valid_589329
  var valid_589330 = query.getOrDefault("alt")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("json"))
  if valid_589330 != nil:
    section.add "alt", valid_589330
  var valid_589331 = query.getOrDefault("oauth_token")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "oauth_token", valid_589331
  var valid_589332 = query.getOrDefault("callback")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "callback", valid_589332
  var valid_589333 = query.getOrDefault("access_token")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "access_token", valid_589333
  var valid_589334 = query.getOrDefault("uploadType")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "uploadType", valid_589334
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
  var valid_589337 = query.getOrDefault("prettyPrint")
  valid_589337 = validateParameter(valid_589337, JBool, required = false,
                                 default = newJBool(true))
  if valid_589337 != nil:
    section.add "prettyPrint", valid_589337
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

proc call*(call_589339: Call_ContaineranalysisProjectsNotesTestIamPermissions_589323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
  ## 
  let valid = call_589339.validator(path, query, header, formData, body)
  let scheme = call_589339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589339.url(scheme.get, call_589339.host, call_589339.base,
                         call_589339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589339, url, valid)

proc call*(call_589340: Call_ContaineranalysisProjectsNotesTestIamPermissions_589323;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containeranalysisProjectsNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence. Requires list permission on the project (for example,
  ## `containeranalysis.notes.list`).
  ## 
  ## The resource takes the format `projects/[PROJECT_ID]/notes/[NOTE_ID]` for
  ## notes and `projects/[PROJECT_ID]/occurrences/[OCCURRENCE_ID]` for
  ## occurrences.
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
  var path_589341 = newJObject()
  var query_589342 = newJObject()
  var body_589343 = newJObject()
  add(query_589342, "upload_protocol", newJString(uploadProtocol))
  add(query_589342, "fields", newJString(fields))
  add(query_589342, "quotaUser", newJString(quotaUser))
  add(query_589342, "alt", newJString(alt))
  add(query_589342, "oauth_token", newJString(oauthToken))
  add(query_589342, "callback", newJString(callback))
  add(query_589342, "access_token", newJString(accessToken))
  add(query_589342, "uploadType", newJString(uploadType))
  add(query_589342, "key", newJString(key))
  add(query_589342, "$.xgafv", newJString(Xgafv))
  add(path_589341, "resource", newJString(resource))
  if body != nil:
    body_589343 = body
  add(query_589342, "prettyPrint", newJBool(prettyPrint))
  result = call_589340.call(path_589341, query_589342, nil, nil, body_589343)

var containeranalysisProjectsNotesTestIamPermissions* = Call_ContaineranalysisProjectsNotesTestIamPermissions_589323(
    name: "containeranalysisProjectsNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProjectsNotesTestIamPermissions_589324,
    base: "/", url: url_ContaineranalysisProjectsNotesTestIamPermissions_589325,
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
