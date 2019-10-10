
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Broker
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Google Cloud Platform Service Broker API provides Google hosted
## implementation of the Open Service Broker API
## (https://www.openservicebrokerapi.org/).
## 
## 
## https://cloud.google.com/kubernetes-engine/docs/concepts/add-on/service-broker
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588710 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588712(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588711(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the instance to return.
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

proc call*(call_588885: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesGet
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the instance to return.
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

var servicebrokerProjectsBrokersV2ServiceInstancesGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588710(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588711,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_588712,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588998 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_589000(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/service_bindings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588999(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the bindings in the instance
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589001 = path.getOrDefault("parent")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "parent", valid_589001
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
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
  var valid_589004 = query.getOrDefault("pageToken")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "pageToken", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("pageSize")
  valid_589013 = validateParameter(valid_589013, JInt, required = false, default = nil)
  if valid_589013 != nil:
    section.add "pageSize", valid_589013
  var valid_589014 = query.getOrDefault("prettyPrint")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(true))
  if valid_589014 != nil:
    section.add "prettyPrint", valid_589014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589015: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance
  ## 
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588998;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersInstancesServiceBindingsList
  ## Lists all the bindings in the instance
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "pageToken", newJString(pageToken))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(path_589017, "parent", newJString(parent))
  add(query_589018, "key", newJString(key))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  add(query_589018, "pageSize", newJInt(pageSize))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  result = call_589016.call(path_589017, query_589018, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesServiceBindingsList* = Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588998(
    name: "servicebrokerProjectsBrokersInstancesServiceBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_bindings", validator: validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_588999,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_589000,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersServiceInstancesList_589019 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersServiceInstancesList_589021(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/service_instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersServiceInstancesList_589020(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589022 = path.getOrDefault("parent")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "parent", valid_589022
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589023 = query.getOrDefault("upload_protocol")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "upload_protocol", valid_589023
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("pageToken")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "pageToken", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("oauth_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "oauth_token", valid_589028
  var valid_589029 = query.getOrDefault("callback")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "callback", valid_589029
  var valid_589030 = query.getOrDefault("access_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "access_token", valid_589030
  var valid_589031 = query.getOrDefault("uploadType")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "uploadType", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("$.xgafv")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("1"))
  if valid_589033 != nil:
    section.add "$.xgafv", valid_589033
  var valid_589034 = query.getOrDefault("pageSize")
  valid_589034 = validateParameter(valid_589034, JInt, required = false, default = nil)
  if valid_589034 != nil:
    section.add "pageSize", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589036: Call_ServicebrokerProjectsBrokersServiceInstancesList_589019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_ServicebrokerProjectsBrokersServiceInstancesList_589019;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersServiceInstancesList
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "pageToken", newJString(pageToken))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(path_589038, "parent", newJString(parent))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  add(query_589039, "pageSize", newJInt(pageSize))
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  result = call_589037.call(path_589038, query_589039, nil, nil, nil)

var servicebrokerProjectsBrokersServiceInstancesList* = Call_ServicebrokerProjectsBrokersServiceInstancesList_589019(
    name: "servicebrokerProjectsBrokersServiceInstancesList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_instances",
    validator: validate_ServicebrokerProjectsBrokersServiceInstancesList_589020,
    base: "/", url: url_ServicebrokerProjectsBrokersServiceInstancesList_589021,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_589040 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2CatalogList_589042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/catalog")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2CatalogList_589041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589043 = path.getOrDefault("parent")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "parent", valid_589043
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("pageToken")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "pageToken", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("pageSize")
  valid_589055 = validateParameter(valid_589055, JInt, required = false, default = nil)
  if valid_589055 != nil:
    section.add "pageSize", valid_589055
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

proc call*(call_589057: Call_ServicebrokerProjectsBrokersV2CatalogList_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_ServicebrokerProjectsBrokersV2CatalogList_589040;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2CatalogList
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "pageToken", newJString(pageToken))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(path_589059, "parent", newJString(parent))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  add(query_589060, "pageSize", newJInt(pageSize))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_589040(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_589041,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_589042,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589061 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589063(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The instance id to deprovision.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589064 = path.getOrDefault("parent")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "parent", valid_589064
  var valid_589065 = path.getOrDefault("instanceId")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "instanceId", valid_589065
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  ##   planId: JString
  ##         : The plan id of the service instance.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : The service id of the service instance.
  section = newJObject()
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
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
  var valid_589070 = query.getOrDefault("acceptsIncomplete")
  valid_589070 = validateParameter(valid_589070, JBool, required = false, default = nil)
  if valid_589070 != nil:
    section.add "acceptsIncomplete", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("$.xgafv")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("1"))
  if valid_589076 != nil:
    section.add "$.xgafv", valid_589076
  var valid_589077 = query.getOrDefault("planId")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "planId", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
  var valid_589079 = query.getOrDefault("serviceId")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "serviceId", valid_589079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589080: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589061;
          parent: string; instanceId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          acceptsIncomplete: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; planId: string = "";
          prettyPrint: bool = true; serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesDelete
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : The instance id to deprovision.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   planId: string
  ##         : The plan id of the service instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : The service id of the service instance.
  var path_589082 = newJObject()
  var query_589083 = newJObject()
  add(query_589083, "upload_protocol", newJString(uploadProtocol))
  add(query_589083, "fields", newJString(fields))
  add(query_589083, "quotaUser", newJString(quotaUser))
  add(query_589083, "alt", newJString(alt))
  add(query_589083, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589083, "oauth_token", newJString(oauthToken))
  add(query_589083, "callback", newJString(callback))
  add(query_589083, "access_token", newJString(accessToken))
  add(query_589083, "uploadType", newJString(uploadType))
  add(path_589082, "parent", newJString(parent))
  add(path_589082, "instanceId", newJString(instanceId))
  add(query_589083, "key", newJString(key))
  add(query_589083, "$.xgafv", newJString(Xgafv))
  add(query_589083, "planId", newJString(planId))
  add(query_589083, "prettyPrint", newJBool(prettyPrint))
  add(query_589083, "serviceId", newJString(serviceId))
  result = call_589081.call(path_589082, query_589083, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589061(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589062,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_589063,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589084 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589086(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/last_operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589085(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The instance id for which to return the last operation status.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589087 = path.getOrDefault("parent")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "parent", valid_589087
  var valid_589088 = path.getOrDefault("instanceId")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "instanceId", valid_589088
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
  ##   planId: JString
  ##         : Plan id.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Service id.
  section = newJObject()
  var valid_589089 = query.getOrDefault("upload_protocol")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "upload_protocol", valid_589089
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("planId")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "planId", valid_589099
  var valid_589100 = query.getOrDefault("operation")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "operation", valid_589100
  var valid_589101 = query.getOrDefault("prettyPrint")
  valid_589101 = validateParameter(valid_589101, JBool, required = false,
                                 default = newJBool(true))
  if valid_589101 != nil:
    section.add "prettyPrint", valid_589101
  var valid_589102 = query.getOrDefault("serviceId")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "serviceId", valid_589102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589103: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589084;
          parent: string; instanceId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          planId: string = ""; operation: string = ""; prettyPrint: bool = true;
          serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : The instance id for which to return the last operation status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   planId: string
  ##         : Plan id.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Service id.
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  add(query_589106, "upload_protocol", newJString(uploadProtocol))
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(query_589106, "callback", newJString(callback))
  add(query_589106, "access_token", newJString(accessToken))
  add(query_589106, "uploadType", newJString(uploadType))
  add(path_589105, "parent", newJString(parent))
  add(path_589105, "instanceId", newJString(instanceId))
  add(query_589106, "key", newJString(key))
  add(query_589106, "$.xgafv", newJString(Xgafv))
  add(query_589106, "planId", newJString(planId))
  add(query_589106, "operation", newJString(operation))
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  add(query_589106, "serviceId", newJString(serviceId))
  result = call_589104.call(path_589105, query_589106, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589084(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589085,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_589086,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589107 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589109(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  assert "bindingId" in path, "`bindingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/service_bindings/"),
               (kind: VariableSegment, value: "bindingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589108(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## GetBinding returns the binding information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : Instance id to which the binding is bound.
  ##   bindingId: JString (required)
  ##            : The binding id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589110 = path.getOrDefault("parent")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "parent", valid_589110
  var valid_589111 = path.getOrDefault("instanceId")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "instanceId", valid_589111
  var valid_589112 = path.getOrDefault("bindingId")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "bindingId", valid_589112
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
  ##   planId: JString
  ##         : Plan id.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Service id.
  section = newJObject()
  var valid_589113 = query.getOrDefault("upload_protocol")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "upload_protocol", valid_589113
  var valid_589114 = query.getOrDefault("fields")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "fields", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("planId")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "planId", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
  var valid_589125 = query.getOrDefault("serviceId")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "serviceId", valid_589125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589126: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589107;
          parent: string; instanceId: string; bindingId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; planId: string = ""; prettyPrint: bool = true;
          serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet
  ## GetBinding returns the binding information.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : Instance id to which the binding is bound.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   planId: string
  ##         : Plan id.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Service id.
  ##   bindingId: string (required)
  ##            : The binding id.
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  add(query_589129, "upload_protocol", newJString(uploadProtocol))
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "callback", newJString(callback))
  add(query_589129, "access_token", newJString(accessToken))
  add(query_589129, "uploadType", newJString(uploadType))
  add(path_589128, "parent", newJString(parent))
  add(path_589128, "instanceId", newJString(instanceId))
  add(query_589129, "key", newJString(key))
  add(query_589129, "$.xgafv", newJString(Xgafv))
  add(query_589129, "planId", newJString(planId))
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  add(query_589129, "serviceId", newJString(serviceId))
  add(path_589128, "bindingId", newJString(bindingId))
  result = call_589127.call(path_589128, query_589129, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589107(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589108,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_589109,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589130 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589132(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  assert "bindingId" in path, "`bindingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/service_bindings/"),
               (kind: VariableSegment, value: "bindingId"),
               (kind: ConstantSegment, value: "/last_operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589131(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The instance id that the binding is bound to.
  ##   bindingId: JString (required)
  ##            : The binding id for which to return the last operation
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589133 = path.getOrDefault("parent")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "parent", valid_589133
  var valid_589134 = path.getOrDefault("instanceId")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "instanceId", valid_589134
  var valid_589135 = path.getOrDefault("bindingId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "bindingId", valid_589135
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
  ##   planId: JString
  ##         : Plan id.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Service id.
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
  var valid_589146 = query.getOrDefault("planId")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "planId", valid_589146
  var valid_589147 = query.getOrDefault("operation")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "operation", valid_589147
  var valid_589148 = query.getOrDefault("prettyPrint")
  valid_589148 = validateParameter(valid_589148, JBool, required = false,
                                 default = newJBool(true))
  if valid_589148 != nil:
    section.add "prettyPrint", valid_589148
  var valid_589149 = query.getOrDefault("serviceId")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "serviceId", valid_589149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589150: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589130;
          parent: string; instanceId: string; bindingId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; planId: string = ""; operation: string = "";
          prettyPrint: bool = true; serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : The instance id that the binding is bound to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   planId: string
  ##         : Plan id.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Service id.
  ##   bindingId: string (required)
  ##            : The binding id for which to return the last operation
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  add(query_589153, "upload_protocol", newJString(uploadProtocol))
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "callback", newJString(callback))
  add(query_589153, "access_token", newJString(accessToken))
  add(query_589153, "uploadType", newJString(uploadType))
  add(path_589152, "parent", newJString(parent))
  add(path_589152, "instanceId", newJString(instanceId))
  add(query_589153, "key", newJString(key))
  add(query_589153, "$.xgafv", newJString(Xgafv))
  add(query_589153, "planId", newJString(planId))
  add(query_589153, "operation", newJString(operation))
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  add(query_589153, "serviceId", newJString(serviceId))
  add(path_589152, "bindingId", newJString(bindingId))
  result = call_589151.call(path_589152, query_589153, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589130(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589131,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589132,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589154 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589156(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  assert "binding_id" in path, "`binding_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/service_bindings/"),
               (kind: VariableSegment, value: "binding_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589155(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The GCP container.
  ## Must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The service instance to which to bind.
  ##   binding_id: JString (required)
  ##             : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589157 = path.getOrDefault("parent")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "parent", valid_589157
  var valid_589158 = path.getOrDefault("instanceId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "instanceId", valid_589158
  var valid_589159 = path.getOrDefault("binding_id")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "binding_id", valid_589159
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  var valid_589160 = query.getOrDefault("upload_protocol")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "upload_protocol", valid_589160
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("acceptsIncomplete")
  valid_589164 = validateParameter(valid_589164, JBool, required = false, default = nil)
  if valid_589164 != nil:
    section.add "acceptsIncomplete", valid_589164
  var valid_589165 = query.getOrDefault("oauth_token")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "oauth_token", valid_589165
  var valid_589166 = query.getOrDefault("callback")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "callback", valid_589166
  var valid_589167 = query.getOrDefault("access_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "access_token", valid_589167
  var valid_589168 = query.getOrDefault("uploadType")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "uploadType", valid_589168
  var valid_589169 = query.getOrDefault("key")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "key", valid_589169
  var valid_589170 = query.getOrDefault("$.xgafv")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("1"))
  if valid_589170 != nil:
    section.add "$.xgafv", valid_589170
  var valid_589171 = query.getOrDefault("prettyPrint")
  valid_589171 = validateParameter(valid_589171, JBool, required = false,
                                 default = newJBool(true))
  if valid_589171 != nil:
    section.add "prettyPrint", valid_589171
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

proc call*(call_589173: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_589173.validator(path, query, header, formData, body)
  let scheme = call_589173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589173.url(scheme.get, call_589173.host, call_589173.base,
                         call_589173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589173, url, valid)

proc call*(call_589174: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589154;
          parent: string; instanceId: string; bindingId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; acceptsIncomplete: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The GCP container.
  ## Must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : The service instance to which to bind.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bindingId: string (required)
  ##            : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589175 = newJObject()
  var query_589176 = newJObject()
  var body_589177 = newJObject()
  add(query_589176, "upload_protocol", newJString(uploadProtocol))
  add(query_589176, "fields", newJString(fields))
  add(query_589176, "quotaUser", newJString(quotaUser))
  add(query_589176, "alt", newJString(alt))
  add(query_589176, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589176, "oauth_token", newJString(oauthToken))
  add(query_589176, "callback", newJString(callback))
  add(query_589176, "access_token", newJString(accessToken))
  add(query_589176, "uploadType", newJString(uploadType))
  add(path_589175, "parent", newJString(parent))
  add(path_589175, "instanceId", newJString(instanceId))
  add(query_589176, "key", newJString(key))
  add(query_589176, "$.xgafv", newJString(Xgafv))
  add(path_589175, "binding_id", newJString(bindingId))
  if body != nil:
    body_589177 = body
  add(query_589176, "prettyPrint", newJBool(prettyPrint))
  result = call_589174.call(path_589175, query_589176, nil, nil, body_589177)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589154(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589155,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589156,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589178 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589180(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instance_id" in path, "`instance_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instance_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589179(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589181 = path.getOrDefault("parent")
  valid_589181 = validateParameter(valid_589181, JString, required = true,
                                 default = nil)
  if valid_589181 != nil:
    section.add "parent", valid_589181
  var valid_589182 = path.getOrDefault("instance_id")
  valid_589182 = validateParameter(valid_589182, JString, required = true,
                                 default = nil)
  if valid_589182 != nil:
    section.add "instance_id", valid_589182
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
  ##   acceptsIncomplete: JBool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
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
  var valid_589183 = query.getOrDefault("upload_protocol")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "upload_protocol", valid_589183
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("quotaUser")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "quotaUser", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("acceptsIncomplete")
  valid_589187 = validateParameter(valid_589187, JBool, required = false, default = nil)
  if valid_589187 != nil:
    section.add "acceptsIncomplete", valid_589187
  var valid_589188 = query.getOrDefault("oauth_token")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "oauth_token", valid_589188
  var valid_589189 = query.getOrDefault("callback")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "callback", valid_589189
  var valid_589190 = query.getOrDefault("access_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "access_token", valid_589190
  var valid_589191 = query.getOrDefault("uploadType")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "uploadType", valid_589191
  var valid_589192 = query.getOrDefault("key")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "key", valid_589192
  var valid_589193 = query.getOrDefault("$.xgafv")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("1"))
  if valid_589193 != nil:
    section.add "$.xgafv", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
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

proc call*(call_589196: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589178;
          parent: string; instanceId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          acceptsIncomplete: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesCreate
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  var path_589198 = newJObject()
  var query_589199 = newJObject()
  var body_589200 = newJObject()
  add(query_589199, "upload_protocol", newJString(uploadProtocol))
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(query_589199, "alt", newJString(alt))
  add(query_589199, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "callback", newJString(callback))
  add(query_589199, "access_token", newJString(accessToken))
  add(query_589199, "uploadType", newJString(uploadType))
  add(path_589198, "parent", newJString(parent))
  add(query_589199, "key", newJString(key))
  add(query_589199, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589200 = body
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  add(path_589198, "instance_id", newJString(instanceId))
  result = call_589197.call(path_589198, query_589199, nil, nil, body_589200)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589178(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589179,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589180,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589201 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589203(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instance_id" in path, "`instance_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instance_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589202(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589204 = path.getOrDefault("parent")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "parent", valid_589204
  var valid_589205 = path.getOrDefault("instance_id")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "instance_id", valid_589205
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  var valid_589206 = query.getOrDefault("upload_protocol")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "upload_protocol", valid_589206
  var valid_589207 = query.getOrDefault("fields")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "fields", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("acceptsIncomplete")
  valid_589210 = validateParameter(valid_589210, JBool, required = false, default = nil)
  if valid_589210 != nil:
    section.add "acceptsIncomplete", valid_589210
  var valid_589211 = query.getOrDefault("oauth_token")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "oauth_token", valid_589211
  var valid_589212 = query.getOrDefault("callback")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "callback", valid_589212
  var valid_589213 = query.getOrDefault("access_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "access_token", valid_589213
  var valid_589214 = query.getOrDefault("uploadType")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "uploadType", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("$.xgafv")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("1"))
  if valid_589216 != nil:
    section.add "$.xgafv", valid_589216
  var valid_589217 = query.getOrDefault("prettyPrint")
  valid_589217 = validateParameter(valid_589217, JBool, required = false,
                                 default = newJBool(true))
  if valid_589217 != nil:
    section.add "prettyPrint", valid_589217
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

proc call*(call_589219: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_589219.validator(path, query, header, formData, body)
  let scheme = call_589219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589219.url(scheme.get, call_589219.host, call_589219.base,
                         call_589219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589219, url, valid)

proc call*(call_589220: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589201;
          parent: string; instanceId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          acceptsIncomplete: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesPatch
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  var path_589221 = newJObject()
  var query_589222 = newJObject()
  var body_589223 = newJObject()
  add(query_589222, "upload_protocol", newJString(uploadProtocol))
  add(query_589222, "fields", newJString(fields))
  add(query_589222, "quotaUser", newJString(quotaUser))
  add(query_589222, "alt", newJString(alt))
  add(query_589222, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589222, "oauth_token", newJString(oauthToken))
  add(query_589222, "callback", newJString(callback))
  add(query_589222, "access_token", newJString(accessToken))
  add(query_589222, "uploadType", newJString(uploadType))
  add(path_589221, "parent", newJString(parent))
  add(query_589222, "key", newJString(key))
  add(query_589222, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589223 = body
  add(query_589222, "prettyPrint", newJBool(prettyPrint))
  add(path_589221, "instance_id", newJString(instanceId))
  result = call_589220.call(path_589221, query_589222, nil, nil, body_589223)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589201(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589202,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589203,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_589224 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerGetIamPolicy_589226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerGetIamPolicy_589225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589227 = path.getOrDefault("resource")
  valid_589227 = validateParameter(valid_589227, JString, required = true,
                                 default = nil)
  if valid_589227 != nil:
    section.add "resource", valid_589227
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
  var valid_589228 = query.getOrDefault("upload_protocol")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "upload_protocol", valid_589228
  var valid_589229 = query.getOrDefault("fields")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "fields", valid_589229
  var valid_589230 = query.getOrDefault("quotaUser")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "quotaUser", valid_589230
  var valid_589231 = query.getOrDefault("alt")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("json"))
  if valid_589231 != nil:
    section.add "alt", valid_589231
  var valid_589232 = query.getOrDefault("oauth_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "oauth_token", valid_589232
  var valid_589233 = query.getOrDefault("callback")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "callback", valid_589233
  var valid_589234 = query.getOrDefault("access_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "access_token", valid_589234
  var valid_589235 = query.getOrDefault("uploadType")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "uploadType", valid_589235
  var valid_589236 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589236 = validateParameter(valid_589236, JInt, required = false, default = nil)
  if valid_589236 != nil:
    section.add "options.requestedPolicyVersion", valid_589236
  var valid_589237 = query.getOrDefault("key")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "key", valid_589237
  var valid_589238 = query.getOrDefault("$.xgafv")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = newJString("1"))
  if valid_589238 != nil:
    section.add "$.xgafv", valid_589238
  var valid_589239 = query.getOrDefault("prettyPrint")
  valid_589239 = validateParameter(valid_589239, JBool, required = false,
                                 default = newJBool(true))
  if valid_589239 != nil:
    section.add "prettyPrint", valid_589239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589240: Call_ServicebrokerGetIamPolicy_589224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589240.validator(path, query, header, formData, body)
  let scheme = call_589240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589240.url(scheme.get, call_589240.host, call_589240.base,
                         call_589240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589240, url, valid)

proc call*(call_589241: Call_ServicebrokerGetIamPolicy_589224; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## servicebrokerGetIamPolicy
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
  var path_589242 = newJObject()
  var query_589243 = newJObject()
  add(query_589243, "upload_protocol", newJString(uploadProtocol))
  add(query_589243, "fields", newJString(fields))
  add(query_589243, "quotaUser", newJString(quotaUser))
  add(query_589243, "alt", newJString(alt))
  add(query_589243, "oauth_token", newJString(oauthToken))
  add(query_589243, "callback", newJString(callback))
  add(query_589243, "access_token", newJString(accessToken))
  add(query_589243, "uploadType", newJString(uploadType))
  add(query_589243, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589243, "key", newJString(key))
  add(query_589243, "$.xgafv", newJString(Xgafv))
  add(path_589242, "resource", newJString(resource))
  add(query_589243, "prettyPrint", newJBool(prettyPrint))
  result = call_589241.call(path_589242, query_589243, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_589224(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_589225, base: "/",
    url: url_ServicebrokerGetIamPolicy_589226, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_589244 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerSetIamPolicy_589246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerSetIamPolicy_589245(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589247 = path.getOrDefault("resource")
  valid_589247 = validateParameter(valid_589247, JString, required = true,
                                 default = nil)
  if valid_589247 != nil:
    section.add "resource", valid_589247
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
  var valid_589248 = query.getOrDefault("upload_protocol")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "upload_protocol", valid_589248
  var valid_589249 = query.getOrDefault("fields")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "fields", valid_589249
  var valid_589250 = query.getOrDefault("quotaUser")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "quotaUser", valid_589250
  var valid_589251 = query.getOrDefault("alt")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = newJString("json"))
  if valid_589251 != nil:
    section.add "alt", valid_589251
  var valid_589252 = query.getOrDefault("oauth_token")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "oauth_token", valid_589252
  var valid_589253 = query.getOrDefault("callback")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "callback", valid_589253
  var valid_589254 = query.getOrDefault("access_token")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "access_token", valid_589254
  var valid_589255 = query.getOrDefault("uploadType")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "uploadType", valid_589255
  var valid_589256 = query.getOrDefault("key")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "key", valid_589256
  var valid_589257 = query.getOrDefault("$.xgafv")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("1"))
  if valid_589257 != nil:
    section.add "$.xgafv", valid_589257
  var valid_589258 = query.getOrDefault("prettyPrint")
  valid_589258 = validateParameter(valid_589258, JBool, required = false,
                                 default = newJBool(true))
  if valid_589258 != nil:
    section.add "prettyPrint", valid_589258
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

proc call*(call_589260: Call_ServicebrokerSetIamPolicy_589244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589260.validator(path, query, header, formData, body)
  let scheme = call_589260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589260.url(scheme.get, call_589260.host, call_589260.base,
                         call_589260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589260, url, valid)

proc call*(call_589261: Call_ServicebrokerSetIamPolicy_589244; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## servicebrokerSetIamPolicy
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
  var path_589262 = newJObject()
  var query_589263 = newJObject()
  var body_589264 = newJObject()
  add(query_589263, "upload_protocol", newJString(uploadProtocol))
  add(query_589263, "fields", newJString(fields))
  add(query_589263, "quotaUser", newJString(quotaUser))
  add(query_589263, "alt", newJString(alt))
  add(query_589263, "oauth_token", newJString(oauthToken))
  add(query_589263, "callback", newJString(callback))
  add(query_589263, "access_token", newJString(accessToken))
  add(query_589263, "uploadType", newJString(uploadType))
  add(query_589263, "key", newJString(key))
  add(query_589263, "$.xgafv", newJString(Xgafv))
  add(path_589262, "resource", newJString(resource))
  if body != nil:
    body_589264 = body
  add(query_589263, "prettyPrint", newJBool(prettyPrint))
  result = call_589261.call(path_589262, query_589263, nil, nil, body_589264)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_589244(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_589245, base: "/",
    url: url_ServicebrokerSetIamPolicy_589246, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_589265 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerTestIamPermissions_589267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerTestIamPermissions_589266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589268 = path.getOrDefault("resource")
  valid_589268 = validateParameter(valid_589268, JString, required = true,
                                 default = nil)
  if valid_589268 != nil:
    section.add "resource", valid_589268
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
  var valid_589269 = query.getOrDefault("upload_protocol")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "upload_protocol", valid_589269
  var valid_589270 = query.getOrDefault("fields")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "fields", valid_589270
  var valid_589271 = query.getOrDefault("quotaUser")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "quotaUser", valid_589271
  var valid_589272 = query.getOrDefault("alt")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("json"))
  if valid_589272 != nil:
    section.add "alt", valid_589272
  var valid_589273 = query.getOrDefault("oauth_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "oauth_token", valid_589273
  var valid_589274 = query.getOrDefault("callback")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "callback", valid_589274
  var valid_589275 = query.getOrDefault("access_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "access_token", valid_589275
  var valid_589276 = query.getOrDefault("uploadType")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "uploadType", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("$.xgafv")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("1"))
  if valid_589278 != nil:
    section.add "$.xgafv", valid_589278
  var valid_589279 = query.getOrDefault("prettyPrint")
  valid_589279 = validateParameter(valid_589279, JBool, required = false,
                                 default = newJBool(true))
  if valid_589279 != nil:
    section.add "prettyPrint", valid_589279
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

proc call*(call_589281: Call_ServicebrokerTestIamPermissions_589265;
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
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_ServicebrokerTestIamPermissions_589265;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerTestIamPermissions
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
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  var body_589285 = newJObject()
  add(query_589284, "upload_protocol", newJString(uploadProtocol))
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(query_589284, "callback", newJString(callback))
  add(query_589284, "access_token", newJString(accessToken))
  add(query_589284, "uploadType", newJString(uploadType))
  add(query_589284, "key", newJString(key))
  add(query_589284, "$.xgafv", newJString(Xgafv))
  add(path_589283, "resource", newJString(resource))
  if body != nil:
    body_589285 = body
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  result = call_589282.call(path_589283, query_589284, nil, nil, body_589285)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_589265(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_589266, base: "/",
    url: url_ServicebrokerTestIamPermissions_589267, schemes: {Scheme.Https})
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
