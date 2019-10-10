
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Usage
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enables services that service consumers want to use on Google Cloud Platform, lists the available or enabled services, or disables services that service consumers no longer use.
## 
## https://cloud.google.com/service-usage/
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
  gcpServiceName = "serviceusage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceusageOperationsList_588719 = ref object of OpenApiRestCall_588450
proc url_ServiceusageOperationsList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServiceusageOperationsList_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  section = newJObject()
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
  ##   name: JString
  ##       : The name of the operation's parent resource.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
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
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("key")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "key", valid_588855
  var valid_588856 = query.getOrDefault("name")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "name", valid_588856
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
  var valid_588860 = query.getOrDefault("filter")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "filter", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_ServiceusageOperationsList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_ServiceusageOperationsList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## serviceusageOperationsList
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
  ##   name: string
  ##       : The name of the operation's parent resource.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var query_588955 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "pageToken", newJString(pageToken))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "key", newJString(key))
  add(query_588955, "name", newJString(name))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "pageSize", newJInt(pageSize))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "filter", newJString(filter))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var serviceusageOperationsList* = Call_ServiceusageOperationsList_588719(
    name: "serviceusageOperationsList", meth: HttpMethod.HttpGet,
    host: "serviceusage.googleapis.com", route: "/v1/operations",
    validator: validate_ServiceusageOperationsList_588720, base: "/",
    url: url_ServiceusageOperationsList_588721, schemes: {Scheme.Https})
type
  Call_ServiceusageServicesGet_588995 = ref object of OpenApiRestCall_588450
proc url_ServiceusageServicesGet_588997(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
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

proc validate_ServiceusageServicesGet_588996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the service configuration and enabled state for a given service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and service to get the `ConsumerState` for.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
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
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("callback")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "callback", valid_589018
  var valid_589019 = query.getOrDefault("access_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "access_token", valid_589019
  var valid_589020 = query.getOrDefault("uploadType")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "uploadType", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("$.xgafv")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("1"))
  if valid_589022 != nil:
    section.add "$.xgafv", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_ServiceusageServicesGet_588995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the service configuration and enabled state for a given service.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_ServiceusageServicesGet_588995; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## serviceusageServicesGet
  ## Returns the service configuration and enabled state for a given service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and service to get the `ConsumerState` for.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
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
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  add(query_589027, "upload_protocol", newJString(uploadProtocol))
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(path_589026, "name", newJString(name))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(query_589027, "callback", newJString(callback))
  add(query_589027, "access_token", newJString(accessToken))
  add(query_589027, "uploadType", newJString(uploadType))
  add(query_589027, "key", newJString(key))
  add(query_589027, "$.xgafv", newJString(Xgafv))
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, nil)

var serviceusageServicesGet* = Call_ServiceusageServicesGet_588995(
    name: "serviceusageServicesGet", meth: HttpMethod.HttpGet,
    host: "serviceusage.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceusageServicesGet_588996, base: "/",
    url: url_ServiceusageServicesGet_588997, schemes: {Scheme.Https})
type
  Call_ServiceusageOperationsDelete_589028 = ref object of OpenApiRestCall_588450
proc url_ServiceusageOperationsDelete_589030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ServiceusageOperationsDelete_589029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
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

proc call*(call_589043: Call_ServiceusageOperationsDelete_589028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_ServiceusageOperationsDelete_589028; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## serviceusageOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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

var serviceusageOperationsDelete* = Call_ServiceusageOperationsDelete_589028(
    name: "serviceusageOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "serviceusage.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceusageOperationsDelete_589029, base: "/",
    url: url_ServiceusageOperationsDelete_589030, schemes: {Scheme.Https})
type
  Call_ServiceusageOperationsCancel_589047 = ref object of OpenApiRestCall_588450
proc url_ServiceusageOperationsCancel_589049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceusageOperationsCancel_589048(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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

proc call*(call_589063: Call_ServiceusageOperationsCancel_589047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_ServiceusageOperationsCancel_589047; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## serviceusageOperationsCancel
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
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  var body_589067 = newJObject()
  add(query_589066, "upload_protocol", newJString(uploadProtocol))
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(path_589065, "name", newJString(name))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "callback", newJString(callback))
  add(query_589066, "access_token", newJString(accessToken))
  add(query_589066, "uploadType", newJString(uploadType))
  add(query_589066, "key", newJString(key))
  add(query_589066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589067 = body
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, body_589067)

var serviceusageOperationsCancel* = Call_ServiceusageOperationsCancel_589047(
    name: "serviceusageOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceusage.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceusageOperationsCancel_589048, base: "/",
    url: url_ServiceusageOperationsCancel_589049, schemes: {Scheme.Https})
type
  Call_ServiceusageServicesDisable_589068 = ref object of OpenApiRestCall_588450
proc url_ServiceusageServicesDisable_589070(protocol: Scheme; host: string;
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

proc validate_ServiceusageServicesDisable_589069(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable a service so that it can no longer be used with a project.
  ## This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## It is not valid to call the disable method on a service that is not
  ## currently enabled. Callers will receive a `FAILED_PRECONDITION` status if
  ## the target service is not currently enabled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and service to disable the service on.
  ## 
  ## The enable and disable methods currently only support projects.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589071 = path.getOrDefault("name")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "name", valid_589071
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
  var valid_589072 = query.getOrDefault("upload_protocol")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "upload_protocol", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("callback")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "callback", valid_589077
  var valid_589078 = query.getOrDefault("access_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "access_token", valid_589078
  var valid_589079 = query.getOrDefault("uploadType")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "uploadType", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("$.xgafv")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("1"))
  if valid_589081 != nil:
    section.add "$.xgafv", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
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

proc call*(call_589084: Call_ServiceusageServicesDisable_589068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Disable a service so that it can no longer be used with a project.
  ## This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## It is not valid to call the disable method on a service that is not
  ## currently enabled. Callers will receive a `FAILED_PRECONDITION` status if
  ## the target service is not currently enabled.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_ServiceusageServicesDisable_589068; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## serviceusageServicesDisable
  ## Disable a service so that it can no longer be used with a project.
  ## This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## It is not valid to call the disable method on a service that is not
  ## currently enabled. Callers will receive a `FAILED_PRECONDITION` status if
  ## the target service is not currently enabled.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and service to disable the service on.
  ## 
  ## The enable and disable methods currently only support projects.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
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
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  var body_589088 = newJObject()
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
  if body != nil:
    body_589088 = body
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, body_589088)

var serviceusageServicesDisable* = Call_ServiceusageServicesDisable_589068(
    name: "serviceusageServicesDisable", meth: HttpMethod.HttpPost,
    host: "serviceusage.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_ServiceusageServicesDisable_589069, base: "/",
    url: url_ServiceusageServicesDisable_589070, schemes: {Scheme.Https})
type
  Call_ServiceusageServicesEnable_589089 = ref object of OpenApiRestCall_588450
proc url_ServiceusageServicesEnable_589091(protocol: Scheme; host: string;
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

proc validate_ServiceusageServicesEnable_589090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable a service so that it can be used with a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and service to enable the service on.
  ## 
  ## The `EnableService` and `DisableService` methods currently only support
  ## projects.
  ## 
  ## Enabling a service requires that the service is public or is shared with
  ## the user enabling the service.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589092 = path.getOrDefault("name")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "name", valid_589092
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
  var valid_589093 = query.getOrDefault("upload_protocol")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "upload_protocol", valid_589093
  var valid_589094 = query.getOrDefault("fields")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "fields", valid_589094
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
  var valid_589103 = query.getOrDefault("prettyPrint")
  valid_589103 = validateParameter(valid_589103, JBool, required = false,
                                 default = newJBool(true))
  if valid_589103 != nil:
    section.add "prettyPrint", valid_589103
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

proc call*(call_589105: Call_ServiceusageServicesEnable_589089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable a service so that it can be used with a project.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_ServiceusageServicesEnable_589089; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## serviceusageServicesEnable
  ## Enable a service so that it can be used with a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and service to enable the service on.
  ## 
  ## The `EnableService` and `DisableService` methods currently only support
  ## projects.
  ## 
  ## Enabling a service requires that the service is public or is shared with
  ## the user enabling the service.
  ## 
  ## An example name would be:
  ## `projects/123/services/serviceusage.googleapis.com` where `123` is the
  ## project number.
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
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "upload_protocol", newJString(uploadProtocol))
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(path_589107, "name", newJString(name))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "callback", newJString(callback))
  add(query_589108, "access_token", newJString(accessToken))
  add(query_589108, "uploadType", newJString(uploadType))
  add(query_589108, "key", newJString(key))
  add(query_589108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, body_589109)

var serviceusageServicesEnable* = Call_ServiceusageServicesEnable_589089(
    name: "serviceusageServicesEnable", meth: HttpMethod.HttpPost,
    host: "serviceusage.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_ServiceusageServicesEnable_589090, base: "/",
    url: url_ServiceusageServicesEnable_589091, schemes: {Scheme.Https})
type
  Call_ServiceusageServicesList_589110 = ref object of OpenApiRestCall_588450
proc url_ServiceusageServicesList_589112(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_ServiceusageServicesList_589111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all services available to the specified project, and the current
  ## state of those services with respect to the project. The list includes
  ## all public services, all services for which the calling user has the
  ## `servicemanagement.services.bind` permission, and all services that have
  ## already been enabled on the project. The list can be filtered to
  ## only include services in a specific state, for example to only include
  ## services enabled on the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent to search for services on.
  ## 
  ## An example name would be:
  ## `projects/123` where `123` is the project number.
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
  ##            : Token identifying which result to start with, which is returned by a
  ## previous list call.
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
  ##           : Requested size of the next page of data.
  ## Requested page size cannot exceed 200.
  ##  If not set, the default page size is 50.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Only list services that conform to the given filter.
  ## The allowed filter strings are `state:ENABLED` and `state:DISABLED`.
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

proc call*(call_589128: Call_ServiceusageServicesList_589110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all services available to the specified project, and the current
  ## state of those services with respect to the project. The list includes
  ## all public services, all services for which the calling user has the
  ## `servicemanagement.services.bind` permission, and all services that have
  ## already been enabled on the project. The list can be filtered to
  ## only include services in a specific state, for example to only include
  ## services enabled on the project.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_ServiceusageServicesList_589110; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## serviceusageServicesList
  ## List all services available to the specified project, and the current
  ## state of those services with respect to the project. The list includes
  ## all public services, all services for which the calling user has the
  ## `servicemanagement.services.bind` permission, and all services that have
  ## already been enabled on the project. The list can be filtered to
  ## only include services in a specific state, for example to only include
  ## services enabled on the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying which result to start with, which is returned by a
  ## previous list call.
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
  ##         : Parent to search for services on.
  ## 
  ## An example name would be:
  ## `projects/123` where `123` is the project number.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested size of the next page of data.
  ## Requested page size cannot exceed 200.
  ##  If not set, the default page size is 50.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Only list services that conform to the given filter.
  ## The allowed filter strings are `state:ENABLED` and `state:DISABLED`.
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

var serviceusageServicesList* = Call_ServiceusageServicesList_589110(
    name: "serviceusageServicesList", meth: HttpMethod.HttpGet,
    host: "serviceusage.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_ServiceusageServicesList_589111, base: "/",
    url: url_ServiceusageServicesList_589112, schemes: {Scheme.Https})
type
  Call_ServiceusageServicesBatchEnable_589132 = ref object of OpenApiRestCall_588450
proc url_ServiceusageServicesBatchEnable_589134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services:batchEnable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceusageServicesBatchEnable_589133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable multiple services on a project. The operation is atomic: if enabling
  ## any service fails, then the entire batch fails, and no state changes occur.
  ## To enable a single service, use the `EnableService` method instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent to enable services on.
  ## 
  ## An example name would be:
  ## `projects/123` where `123` is the project number.
  ## 
  ## The `BatchEnableServices` method currently only supports projects.
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
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("callback")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "callback", valid_589141
  var valid_589142 = query.getOrDefault("access_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "access_token", valid_589142
  var valid_589143 = query.getOrDefault("uploadType")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "uploadType", valid_589143
  var valid_589144 = query.getOrDefault("key")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "key", valid_589144
  var valid_589145 = query.getOrDefault("$.xgafv")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("1"))
  if valid_589145 != nil:
    section.add "$.xgafv", valid_589145
  var valid_589146 = query.getOrDefault("prettyPrint")
  valid_589146 = validateParameter(valid_589146, JBool, required = false,
                                 default = newJBool(true))
  if valid_589146 != nil:
    section.add "prettyPrint", valid_589146
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

proc call*(call_589148: Call_ServiceusageServicesBatchEnable_589132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enable multiple services on a project. The operation is atomic: if enabling
  ## any service fails, then the entire batch fails, and no state changes occur.
  ## To enable a single service, use the `EnableService` method instead.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_ServiceusageServicesBatchEnable_589132;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## serviceusageServicesBatchEnable
  ## Enable multiple services on a project. The operation is atomic: if enabling
  ## any service fails, then the entire batch fails, and no state changes occur.
  ## To enable a single service, use the `EnableService` method instead.
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
  ##         : Parent to enable services on.
  ## 
  ## An example name would be:
  ## `projects/123` where `123` is the project number.
  ## 
  ## The `BatchEnableServices` method currently only supports projects.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  var body_589152 = newJObject()
  add(query_589151, "upload_protocol", newJString(uploadProtocol))
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(query_589151, "callback", newJString(callback))
  add(query_589151, "access_token", newJString(accessToken))
  add(query_589151, "uploadType", newJString(uploadType))
  add(path_589150, "parent", newJString(parent))
  add(query_589151, "key", newJString(key))
  add(query_589151, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589152 = body
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, body_589152)

var serviceusageServicesBatchEnable* = Call_ServiceusageServicesBatchEnable_589132(
    name: "serviceusageServicesBatchEnable", meth: HttpMethod.HttpPost,
    host: "serviceusage.googleapis.com",
    route: "/v1/{parent}/services:batchEnable",
    validator: validate_ServiceusageServicesBatchEnable_589133, base: "/",
    url: url_ServiceusageServicesBatchEnable_589134, schemes: {Scheme.Https})
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
