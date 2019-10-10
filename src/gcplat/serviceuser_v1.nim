
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service User
## version: v1
## termsOfService: (not provided)
## license: (not provided)
## 
## Enables services that service consumers want to use on Google Cloud Platform, lists the available or enabled services, or disables services that service consumers no longer use.
## 
## https://cloud.google.com/service-management/
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
  gcpServiceName = "serviceuser"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceuserServicesSearch_588719 = ref object of OpenApiRestCall_588450
proc url_ServiceuserServicesSearch_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServiceuserServicesSearch_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##           : Requested size of the next page of data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("pp")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "pp", valid_588851
  var valid_588852 = query.getOrDefault("oauth_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "oauth_token", valid_588852
  var valid_588853 = query.getOrDefault("callback")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "callback", valid_588853
  var valid_588854 = query.getOrDefault("access_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "access_token", valid_588854
  var valid_588855 = query.getOrDefault("uploadType")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "uploadType", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  var valid_588860 = query.getOrDefault("bearer_token")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "bearer_token", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_ServiceuserServicesSearch_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_ServiceuserServicesSearch_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## serviceuserServicesSearch
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##           : Requested size of the next page of data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_588955 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "pageToken", newJString(pageToken))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "pp", newJBool(pp))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "key", newJString(key))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "pageSize", newJInt(pageSize))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "bearer_token", newJString(bearerToken))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var serviceuserServicesSearch* = Call_ServiceuserServicesSearch_588719(
    name: "serviceuserServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceuser.googleapis.com", route: "/v1/services:search",
    validator: validate_ServiceuserServicesSearch_588720, base: "/",
    url: url_ServiceuserServicesSearch_588721, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesDisable_588995 = ref object of OpenApiRestCall_588450
proc url_ServiceuserProjectsServicesDisable_588997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesDisable_588996(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and the service to disable for that consumer.
  ## 
  ## The Service User implementation accepts the following forms for consumer:
  ## - "project:<project_id>"
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:disable
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589012 = path.getOrDefault("name")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "name", valid_589012
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("pp")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "pp", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("callback")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "callback", valid_589019
  var valid_589020 = query.getOrDefault("access_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "access_token", valid_589020
  var valid_589021 = query.getOrDefault("uploadType")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "uploadType", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
  var valid_589025 = query.getOrDefault("bearer_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "bearer_token", valid_589025
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

proc call*(call_589027: Call_ServiceuserProjectsServicesDisable_588995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_ServiceuserProjectsServicesDisable_588995;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## serviceuserProjectsServicesDisable
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and the service to disable for that consumer.
  ## 
  ## The Service User implementation accepts the following forms for consumer:
  ## - "project:<project_id>"
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:disable
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589029 = newJObject()
  var query_589030 = newJObject()
  var body_589031 = newJObject()
  add(query_589030, "upload_protocol", newJString(uploadProtocol))
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(path_589029, "name", newJString(name))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "pp", newJBool(pp))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "callback", newJString(callback))
  add(query_589030, "access_token", newJString(accessToken))
  add(query_589030, "uploadType", newJString(uploadType))
  add(query_589030, "key", newJString(key))
  add(query_589030, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589031 = body
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  add(query_589030, "bearer_token", newJString(bearerToken))
  result = call_589028.call(path_589029, query_589030, nil, nil, body_589031)

var serviceuserProjectsServicesDisable* = Call_ServiceuserProjectsServicesDisable_588995(
    name: "serviceuserProjectsServicesDisable", meth: HttpMethod.HttpPost,
    host: "serviceuser.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_ServiceuserProjectsServicesDisable_588996, base: "/",
    url: url_ServiceuserProjectsServicesDisable_588997, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesEnable_589032 = ref object of OpenApiRestCall_588450
proc url_ServiceuserProjectsServicesEnable_589034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesEnable_589033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and the service to enable for that consumer.
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:enable
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589035 = path.getOrDefault("name")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "name", valid_589035
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589036 = query.getOrDefault("upload_protocol")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "upload_protocol", valid_589036
  var valid_589037 = query.getOrDefault("fields")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "fields", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("pp")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "pp", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("uploadType")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "uploadType", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  var valid_589046 = query.getOrDefault("$.xgafv")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = newJString("1"))
  if valid_589046 != nil:
    section.add "$.xgafv", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  var valid_589048 = query.getOrDefault("bearer_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "bearer_token", valid_589048
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

proc call*(call_589050: Call_ServiceuserProjectsServicesEnable_589032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_589050.validator(path, query, header, formData, body)
  let scheme = call_589050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589050.url(scheme.get, call_589050.host, call_589050.base,
                         call_589050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589050, url, valid)

proc call*(call_589051: Call_ServiceuserProjectsServicesEnable_589032;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## serviceuserProjectsServicesEnable
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and the service to enable for that consumer.
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:enable
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589052 = newJObject()
  var query_589053 = newJObject()
  var body_589054 = newJObject()
  add(query_589053, "upload_protocol", newJString(uploadProtocol))
  add(query_589053, "fields", newJString(fields))
  add(query_589053, "quotaUser", newJString(quotaUser))
  add(path_589052, "name", newJString(name))
  add(query_589053, "alt", newJString(alt))
  add(query_589053, "pp", newJBool(pp))
  add(query_589053, "oauth_token", newJString(oauthToken))
  add(query_589053, "callback", newJString(callback))
  add(query_589053, "access_token", newJString(accessToken))
  add(query_589053, "uploadType", newJString(uploadType))
  add(query_589053, "key", newJString(key))
  add(query_589053, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589054 = body
  add(query_589053, "prettyPrint", newJBool(prettyPrint))
  add(query_589053, "bearer_token", newJString(bearerToken))
  result = call_589051.call(path_589052, query_589053, nil, nil, body_589054)

var serviceuserProjectsServicesEnable* = Call_ServiceuserProjectsServicesEnable_589032(
    name: "serviceuserProjectsServicesEnable", meth: HttpMethod.HttpPost,
    host: "serviceuser.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_ServiceuserProjectsServicesEnable_589033, base: "/",
    url: url_ServiceuserProjectsServicesEnable_589034, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesList_589055 = ref object of OpenApiRestCall_588450
proc url_ServiceuserProjectsServicesList_589057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesList_589056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List enabled services for the specified consumer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : List enabled services for the specified parent.
  ## 
  ## An example valid parent would be:
  ## - projects/my-project
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589058 = path.getOrDefault("parent")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "parent", valid_589058
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##           : Requested size of the next page of data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("pageToken")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "pageToken", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("pp")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "pp", valid_589064
  var valid_589065 = query.getOrDefault("oauth_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "oauth_token", valid_589065
  var valid_589066 = query.getOrDefault("callback")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "callback", valid_589066
  var valid_589067 = query.getOrDefault("access_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "access_token", valid_589067
  var valid_589068 = query.getOrDefault("uploadType")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "uploadType", valid_589068
  var valid_589069 = query.getOrDefault("key")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "key", valid_589069
  var valid_589070 = query.getOrDefault("$.xgafv")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("1"))
  if valid_589070 != nil:
    section.add "$.xgafv", valid_589070
  var valid_589071 = query.getOrDefault("pageSize")
  valid_589071 = validateParameter(valid_589071, JInt, required = false, default = nil)
  if valid_589071 != nil:
    section.add "pageSize", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
  var valid_589073 = query.getOrDefault("bearer_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "bearer_token", valid_589073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589074: Call_ServiceuserProjectsServicesList_589055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List enabled services for the specified consumer.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_ServiceuserProjectsServicesList_589055;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## serviceuserProjectsServicesList
  ## List enabled services for the specified consumer.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : List enabled services for the specified parent.
  ## 
  ## An example valid parent would be:
  ## - projects/my-project
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested size of the next page of data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "pageToken", newJString(pageToken))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "pp", newJBool(pp))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(path_589076, "parent", newJString(parent))
  add(query_589077, "key", newJString(key))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  add(query_589077, "pageSize", newJInt(pageSize))
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  add(query_589077, "bearer_token", newJString(bearerToken))
  result = call_589075.call(path_589076, query_589077, nil, nil, nil)

var serviceuserProjectsServicesList* = Call_ServiceuserProjectsServicesList_589055(
    name: "serviceuserProjectsServicesList", meth: HttpMethod.HttpGet,
    host: "serviceuser.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_ServiceuserProjectsServicesList_589056, base: "/",
    url: url_ServiceuserProjectsServicesList_589057, schemes: {Scheme.Https})
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
