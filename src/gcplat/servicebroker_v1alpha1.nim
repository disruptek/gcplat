
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579677 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579679(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579678(
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

proc call*(call_579852: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579677;
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

var servicebrokerProjectsBrokersV2ServiceInstancesGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579677(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579678,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_579679,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579965 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579967(
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

proc validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579966(
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
  var valid_579968 = path.getOrDefault("parent")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "parent", valid_579968
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
  var valid_579971 = query.getOrDefault("pageToken")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "pageToken", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("pageSize")
  valid_579980 = validateParameter(valid_579980, JInt, required = false, default = nil)
  if valid_579980 != nil:
    section.add "pageSize", valid_579980
  var valid_579981 = query.getOrDefault("prettyPrint")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "prettyPrint", valid_579981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579982: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance
  ## 
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579965;
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
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "pageToken", newJString(pageToken))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "uploadType", newJString(uploadType))
  add(path_579984, "parent", newJString(parent))
  add(query_579985, "key", newJString(key))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(query_579985, "pageSize", newJInt(pageSize))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  result = call_579983.call(path_579984, query_579985, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesServiceBindingsList* = Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579965(
    name: "servicebrokerProjectsBrokersInstancesServiceBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_bindings", validator: validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579966,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_579967,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersServiceInstancesList_579986 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersServiceInstancesList_579988(
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

proc validate_ServicebrokerProjectsBrokersServiceInstancesList_579987(
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
  var valid_579989 = path.getOrDefault("parent")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "parent", valid_579989
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("pageToken")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "pageToken", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("callback")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "callback", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("pageSize")
  valid_580001 = validateParameter(valid_580001, JInt, required = false, default = nil)
  if valid_580001 != nil:
    section.add "pageSize", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580003: Call_ServicebrokerProjectsBrokersServiceInstancesList_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_ServicebrokerProjectsBrokersServiceInstancesList_579986;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "pageToken", newJString(pageToken))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(path_580005, "parent", newJString(parent))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  add(query_580006, "pageSize", newJInt(pageSize))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  result = call_580004.call(path_580005, query_580006, nil, nil, nil)

var servicebrokerProjectsBrokersServiceInstancesList* = Call_ServicebrokerProjectsBrokersServiceInstancesList_579986(
    name: "servicebrokerProjectsBrokersServiceInstancesList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_instances",
    validator: validate_ServicebrokerProjectsBrokersServiceInstancesList_579987,
    base: "/", url: url_ServicebrokerProjectsBrokersServiceInstancesList_579988,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_580007 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2CatalogList_580009(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersV2CatalogList_580008(path: JsonNode;
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
  var valid_580010 = path.getOrDefault("parent")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "parent", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("pageToken")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "pageToken", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("uploadType")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "uploadType", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("pageSize")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "pageSize", valid_580022
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

proc call*(call_580024: Call_ServicebrokerProjectsBrokersV2CatalogList_580007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_ServicebrokerProjectsBrokersV2CatalogList_580007;
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(path_580026, "parent", newJString(parent))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "pageSize", newJInt(pageSize))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_580007(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_580008,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_580009,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580028 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580030(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580029(
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
  var valid_580031 = path.getOrDefault("parent")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "parent", valid_580031
  var valid_580032 = path.getOrDefault("instanceId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "instanceId", valid_580032
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
  var valid_580033 = query.getOrDefault("upload_protocol")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "upload_protocol", valid_580033
  var valid_580034 = query.getOrDefault("fields")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "fields", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("acceptsIncomplete")
  valid_580037 = validateParameter(valid_580037, JBool, required = false, default = nil)
  if valid_580037 != nil:
    section.add "acceptsIncomplete", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("planId")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "planId", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  var valid_580046 = query.getOrDefault("serviceId")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "serviceId", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580028;
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
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  add(query_580050, "upload_protocol", newJString(uploadProtocol))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "callback", newJString(callback))
  add(query_580050, "access_token", newJString(accessToken))
  add(query_580050, "uploadType", newJString(uploadType))
  add(path_580049, "parent", newJString(parent))
  add(path_580049, "instanceId", newJString(instanceId))
  add(query_580050, "key", newJString(key))
  add(query_580050, "$.xgafv", newJString(Xgafv))
  add(query_580050, "planId", newJString(planId))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  add(query_580050, "serviceId", newJString(serviceId))
  result = call_580048.call(path_580049, query_580050, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580028(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580029,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_580030,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580051 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580053(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580052(
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
  var valid_580054 = path.getOrDefault("parent")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "parent", valid_580054
  var valid_580055 = path.getOrDefault("instanceId")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "instanceId", valid_580055
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
  var valid_580056 = query.getOrDefault("upload_protocol")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "upload_protocol", valid_580056
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("planId")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "planId", valid_580066
  var valid_580067 = query.getOrDefault("operation")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "operation", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
  var valid_580069 = query.getOrDefault("serviceId")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "serviceId", valid_580069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580070: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580051;
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
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "uploadType", newJString(uploadType))
  add(path_580072, "parent", newJString(parent))
  add(path_580072, "instanceId", newJString(instanceId))
  add(query_580073, "key", newJString(key))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  add(query_580073, "planId", newJString(planId))
  add(query_580073, "operation", newJString(operation))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "serviceId", newJString(serviceId))
  result = call_580071.call(path_580072, query_580073, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580051(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580052,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_580053,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580074 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580076(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580075(
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
  var valid_580077 = path.getOrDefault("parent")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "parent", valid_580077
  var valid_580078 = path.getOrDefault("instanceId")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "instanceId", valid_580078
  var valid_580079 = path.getOrDefault("bindingId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "bindingId", valid_580079
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
  var valid_580080 = query.getOrDefault("upload_protocol")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "upload_protocol", valid_580080
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("alt")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("json"))
  if valid_580083 != nil:
    section.add "alt", valid_580083
  var valid_580084 = query.getOrDefault("oauth_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "oauth_token", valid_580084
  var valid_580085 = query.getOrDefault("callback")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "callback", valid_580085
  var valid_580086 = query.getOrDefault("access_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "access_token", valid_580086
  var valid_580087 = query.getOrDefault("uploadType")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "uploadType", valid_580087
  var valid_580088 = query.getOrDefault("key")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "key", valid_580088
  var valid_580089 = query.getOrDefault("$.xgafv")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("1"))
  if valid_580089 != nil:
    section.add "$.xgafv", valid_580089
  var valid_580090 = query.getOrDefault("planId")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "planId", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
  var valid_580092 = query.getOrDefault("serviceId")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "serviceId", valid_580092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580093: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580074;
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
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  add(query_580096, "upload_protocol", newJString(uploadProtocol))
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "callback", newJString(callback))
  add(query_580096, "access_token", newJString(accessToken))
  add(query_580096, "uploadType", newJString(uploadType))
  add(path_580095, "parent", newJString(parent))
  add(path_580095, "instanceId", newJString(instanceId))
  add(query_580096, "key", newJString(key))
  add(query_580096, "$.xgafv", newJString(Xgafv))
  add(query_580096, "planId", newJString(planId))
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  add(query_580096, "serviceId", newJString(serviceId))
  add(path_580095, "bindingId", newJString(bindingId))
  result = call_580094.call(path_580095, query_580096, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580074(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580075,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_580076,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580097 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580099(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580098(
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
  var valid_580100 = path.getOrDefault("parent")
  valid_580100 = validateParameter(valid_580100, JString, required = true,
                                 default = nil)
  if valid_580100 != nil:
    section.add "parent", valid_580100
  var valid_580101 = path.getOrDefault("instanceId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "instanceId", valid_580101
  var valid_580102 = path.getOrDefault("bindingId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "bindingId", valid_580102
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
  var valid_580103 = query.getOrDefault("upload_protocol")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "upload_protocol", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
  var valid_580107 = query.getOrDefault("oauth_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "oauth_token", valid_580107
  var valid_580108 = query.getOrDefault("callback")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "callback", valid_580108
  var valid_580109 = query.getOrDefault("access_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "access_token", valid_580109
  var valid_580110 = query.getOrDefault("uploadType")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "uploadType", valid_580110
  var valid_580111 = query.getOrDefault("key")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "key", valid_580111
  var valid_580112 = query.getOrDefault("$.xgafv")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("1"))
  if valid_580112 != nil:
    section.add "$.xgafv", valid_580112
  var valid_580113 = query.getOrDefault("planId")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "planId", valid_580113
  var valid_580114 = query.getOrDefault("operation")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "operation", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
  var valid_580116 = query.getOrDefault("serviceId")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "serviceId", valid_580116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580117: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580097;
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
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  add(query_580120, "upload_protocol", newJString(uploadProtocol))
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "callback", newJString(callback))
  add(query_580120, "access_token", newJString(accessToken))
  add(query_580120, "uploadType", newJString(uploadType))
  add(path_580119, "parent", newJString(parent))
  add(path_580119, "instanceId", newJString(instanceId))
  add(query_580120, "key", newJString(key))
  add(query_580120, "$.xgafv", newJString(Xgafv))
  add(query_580120, "planId", newJString(planId))
  add(query_580120, "operation", newJString(operation))
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  add(query_580120, "serviceId", newJString(serviceId))
  add(path_580119, "bindingId", newJString(bindingId))
  result = call_580118.call(path_580119, query_580120, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580097(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580098,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580099,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580121 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580123(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580122(
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
  var valid_580124 = path.getOrDefault("parent")
  valid_580124 = validateParameter(valid_580124, JString, required = true,
                                 default = nil)
  if valid_580124 != nil:
    section.add "parent", valid_580124
  var valid_580125 = path.getOrDefault("instanceId")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "instanceId", valid_580125
  var valid_580126 = path.getOrDefault("binding_id")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "binding_id", valid_580126
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
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("acceptsIncomplete")
  valid_580131 = validateParameter(valid_580131, JBool, required = false, default = nil)
  if valid_580131 != nil:
    section.add "acceptsIncomplete", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("callback")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "callback", valid_580133
  var valid_580134 = query.getOrDefault("access_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "access_token", valid_580134
  var valid_580135 = query.getOrDefault("uploadType")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "uploadType", valid_580135
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("$.xgafv")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("1"))
  if valid_580137 != nil:
    section.add "$.xgafv", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
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

proc call*(call_580140: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580121;
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
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  var body_580144 = newJObject()
  add(query_580143, "upload_protocol", newJString(uploadProtocol))
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "callback", newJString(callback))
  add(query_580143, "access_token", newJString(accessToken))
  add(query_580143, "uploadType", newJString(uploadType))
  add(path_580142, "parent", newJString(parent))
  add(path_580142, "instanceId", newJString(instanceId))
  add(query_580143, "key", newJString(key))
  add(query_580143, "$.xgafv", newJString(Xgafv))
  add(path_580142, "binding_id", newJString(bindingId))
  if body != nil:
    body_580144 = body
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  result = call_580141.call(path_580142, query_580143, nil, nil, body_580144)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580121(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580122,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580123,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580145 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580147(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580146(
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
  var valid_580148 = path.getOrDefault("parent")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "parent", valid_580148
  var valid_580149 = path.getOrDefault("instance_id")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "instance_id", valid_580149
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
  var valid_580150 = query.getOrDefault("upload_protocol")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "upload_protocol", valid_580150
  var valid_580151 = query.getOrDefault("fields")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "fields", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("acceptsIncomplete")
  valid_580154 = validateParameter(valid_580154, JBool, required = false, default = nil)
  if valid_580154 != nil:
    section.add "acceptsIncomplete", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("callback")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "callback", valid_580156
  var valid_580157 = query.getOrDefault("access_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "access_token", valid_580157
  var valid_580158 = query.getOrDefault("uploadType")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "uploadType", valid_580158
  var valid_580159 = query.getOrDefault("key")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "key", valid_580159
  var valid_580160 = query.getOrDefault("$.xgafv")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("1"))
  if valid_580160 != nil:
    section.add "$.xgafv", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
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

proc call*(call_580163: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580145;
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
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580145;
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
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  var body_580167 = newJObject()
  add(query_580166, "upload_protocol", newJString(uploadProtocol))
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "callback", newJString(callback))
  add(query_580166, "access_token", newJString(accessToken))
  add(query_580166, "uploadType", newJString(uploadType))
  add(path_580165, "parent", newJString(parent))
  add(query_580166, "key", newJString(key))
  add(query_580166, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580167 = body
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  add(path_580165, "instance_id", newJString(instanceId))
  result = call_580164.call(path_580165, query_580166, nil, nil, body_580167)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580145(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580146,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580147,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580168 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580170(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580169(
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
  var valid_580171 = path.getOrDefault("parent")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "parent", valid_580171
  var valid_580172 = path.getOrDefault("instance_id")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "instance_id", valid_580172
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
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("acceptsIncomplete")
  valid_580177 = validateParameter(valid_580177, JBool, required = false, default = nil)
  if valid_580177 != nil:
    section.add "acceptsIncomplete", valid_580177
  var valid_580178 = query.getOrDefault("oauth_token")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "oauth_token", valid_580178
  var valid_580179 = query.getOrDefault("callback")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "callback", valid_580179
  var valid_580180 = query.getOrDefault("access_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "access_token", valid_580180
  var valid_580181 = query.getOrDefault("uploadType")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "uploadType", valid_580181
  var valid_580182 = query.getOrDefault("key")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "key", valid_580182
  var valid_580183 = query.getOrDefault("$.xgafv")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("1"))
  if valid_580183 != nil:
    section.add "$.xgafv", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
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

proc call*(call_580186: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580168;
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
  var path_580188 = newJObject()
  var query_580189 = newJObject()
  var body_580190 = newJObject()
  add(query_580189, "upload_protocol", newJString(uploadProtocol))
  add(query_580189, "fields", newJString(fields))
  add(query_580189, "quotaUser", newJString(quotaUser))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(query_580189, "callback", newJString(callback))
  add(query_580189, "access_token", newJString(accessToken))
  add(query_580189, "uploadType", newJString(uploadType))
  add(path_580188, "parent", newJString(parent))
  add(query_580189, "key", newJString(key))
  add(query_580189, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580190 = body
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  add(path_580188, "instance_id", newJString(instanceId))
  result = call_580187.call(path_580188, query_580189, nil, nil, body_580190)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580168(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580169,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_580170,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_580191 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerGetIamPolicy_580193(protocol: Scheme; host: string;
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

proc validate_ServicebrokerGetIamPolicy_580192(path: JsonNode; query: JsonNode;
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
  var valid_580194 = path.getOrDefault("resource")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "resource", valid_580194
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
  var valid_580195 = query.getOrDefault("upload_protocol")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "upload_protocol", valid_580195
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("alt")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("json"))
  if valid_580198 != nil:
    section.add "alt", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("callback")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "callback", valid_580200
  var valid_580201 = query.getOrDefault("access_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "access_token", valid_580201
  var valid_580202 = query.getOrDefault("uploadType")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "uploadType", valid_580202
  var valid_580203 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580203 = validateParameter(valid_580203, JInt, required = false, default = nil)
  if valid_580203 != nil:
    section.add "options.requestedPolicyVersion", valid_580203
  var valid_580204 = query.getOrDefault("key")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "key", valid_580204
  var valid_580205 = query.getOrDefault("$.xgafv")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("1"))
  if valid_580205 != nil:
    section.add "$.xgafv", valid_580205
  var valid_580206 = query.getOrDefault("prettyPrint")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "prettyPrint", valid_580206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580207: Call_ServicebrokerGetIamPolicy_580191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580207.validator(path, query, header, formData, body)
  let scheme = call_580207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580207.url(scheme.get, call_580207.host, call_580207.base,
                         call_580207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580207, url, valid)

proc call*(call_580208: Call_ServicebrokerGetIamPolicy_580191; resource: string;
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
  var path_580209 = newJObject()
  var query_580210 = newJObject()
  add(query_580210, "upload_protocol", newJString(uploadProtocol))
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "callback", newJString(callback))
  add(query_580210, "access_token", newJString(accessToken))
  add(query_580210, "uploadType", newJString(uploadType))
  add(query_580210, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580210, "key", newJString(key))
  add(query_580210, "$.xgafv", newJString(Xgafv))
  add(path_580209, "resource", newJString(resource))
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  result = call_580208.call(path_580209, query_580210, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_580191(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_580192, base: "/",
    url: url_ServicebrokerGetIamPolicy_580193, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_580211 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerSetIamPolicy_580213(protocol: Scheme; host: string;
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

proc validate_ServicebrokerSetIamPolicy_580212(path: JsonNode; query: JsonNode;
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
  var valid_580214 = path.getOrDefault("resource")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "resource", valid_580214
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
  var valid_580215 = query.getOrDefault("upload_protocol")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "upload_protocol", valid_580215
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("quotaUser")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "quotaUser", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("callback")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "callback", valid_580220
  var valid_580221 = query.getOrDefault("access_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "access_token", valid_580221
  var valid_580222 = query.getOrDefault("uploadType")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "uploadType", valid_580222
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("$.xgafv")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("1"))
  if valid_580224 != nil:
    section.add "$.xgafv", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
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

proc call*(call_580227: Call_ServicebrokerSetIamPolicy_580211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_ServicebrokerSetIamPolicy_580211; resource: string;
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
  var path_580229 = newJObject()
  var query_580230 = newJObject()
  var body_580231 = newJObject()
  add(query_580230, "upload_protocol", newJString(uploadProtocol))
  add(query_580230, "fields", newJString(fields))
  add(query_580230, "quotaUser", newJString(quotaUser))
  add(query_580230, "alt", newJString(alt))
  add(query_580230, "oauth_token", newJString(oauthToken))
  add(query_580230, "callback", newJString(callback))
  add(query_580230, "access_token", newJString(accessToken))
  add(query_580230, "uploadType", newJString(uploadType))
  add(query_580230, "key", newJString(key))
  add(query_580230, "$.xgafv", newJString(Xgafv))
  add(path_580229, "resource", newJString(resource))
  if body != nil:
    body_580231 = body
  add(query_580230, "prettyPrint", newJBool(prettyPrint))
  result = call_580228.call(path_580229, query_580230, nil, nil, body_580231)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_580211(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_580212, base: "/",
    url: url_ServicebrokerSetIamPolicy_580213, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_580232 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerTestIamPermissions_580234(protocol: Scheme; host: string;
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

proc validate_ServicebrokerTestIamPermissions_580233(path: JsonNode;
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
  var valid_580235 = path.getOrDefault("resource")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "resource", valid_580235
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
  var valid_580236 = query.getOrDefault("upload_protocol")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "upload_protocol", valid_580236
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
  var valid_580238 = query.getOrDefault("quotaUser")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "quotaUser", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("callback")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "callback", valid_580241
  var valid_580242 = query.getOrDefault("access_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "access_token", valid_580242
  var valid_580243 = query.getOrDefault("uploadType")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "uploadType", valid_580243
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("$.xgafv")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("1"))
  if valid_580245 != nil:
    section.add "$.xgafv", valid_580245
  var valid_580246 = query.getOrDefault("prettyPrint")
  valid_580246 = validateParameter(valid_580246, JBool, required = false,
                                 default = newJBool(true))
  if valid_580246 != nil:
    section.add "prettyPrint", valid_580246
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

proc call*(call_580248: Call_ServicebrokerTestIamPermissions_580232;
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
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_ServicebrokerTestIamPermissions_580232;
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
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  var body_580252 = newJObject()
  add(query_580251, "upload_protocol", newJString(uploadProtocol))
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "callback", newJString(callback))
  add(query_580251, "access_token", newJString(accessToken))
  add(query_580251, "uploadType", newJString(uploadType))
  add(query_580251, "key", newJString(key))
  add(query_580251, "$.xgafv", newJString(Xgafv))
  add(path_580250, "resource", newJString(resource))
  if body != nil:
    body_580252 = body
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  result = call_580249.call(path_580250, query_580251, nil, nil, body_580252)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_580232(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_580233, base: "/",
    url: url_ServicebrokerTestIamPermissions_580234, schemes: {Scheme.Https})
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
