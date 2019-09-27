
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593677 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593678(
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
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593677;
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593677(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593678,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_593679,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593965 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593967(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593966(
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
  var valid_593968 = path.getOrDefault("parent")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "parent", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("pageToken")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "pageToken", valid_593971
  var valid_593972 = query.getOrDefault("quotaUser")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "quotaUser", valid_593972
  var valid_593973 = query.getOrDefault("alt")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString("json"))
  if valid_593973 != nil:
    section.add "alt", valid_593973
  var valid_593974 = query.getOrDefault("oauth_token")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "oauth_token", valid_593974
  var valid_593975 = query.getOrDefault("callback")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "callback", valid_593975
  var valid_593976 = query.getOrDefault("access_token")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "access_token", valid_593976
  var valid_593977 = query.getOrDefault("uploadType")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "uploadType", valid_593977
  var valid_593978 = query.getOrDefault("key")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "key", valid_593978
  var valid_593979 = query.getOrDefault("$.xgafv")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("1"))
  if valid_593979 != nil:
    section.add "$.xgafv", valid_593979
  var valid_593980 = query.getOrDefault("pageSize")
  valid_593980 = validateParameter(valid_593980, JInt, required = false, default = nil)
  if valid_593980 != nil:
    section.add "pageSize", valid_593980
  var valid_593981 = query.getOrDefault("prettyPrint")
  valid_593981 = validateParameter(valid_593981, JBool, required = false,
                                 default = newJBool(true))
  if valid_593981 != nil:
    section.add "prettyPrint", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593965;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(query_593985, "upload_protocol", newJString(uploadProtocol))
  add(query_593985, "fields", newJString(fields))
  add(query_593985, "pageToken", newJString(pageToken))
  add(query_593985, "quotaUser", newJString(quotaUser))
  add(query_593985, "alt", newJString(alt))
  add(query_593985, "oauth_token", newJString(oauthToken))
  add(query_593985, "callback", newJString(callback))
  add(query_593985, "access_token", newJString(accessToken))
  add(query_593985, "uploadType", newJString(uploadType))
  add(path_593984, "parent", newJString(parent))
  add(query_593985, "key", newJString(key))
  add(query_593985, "$.xgafv", newJString(Xgafv))
  add(query_593985, "pageSize", newJInt(pageSize))
  add(query_593985, "prettyPrint", newJBool(prettyPrint))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesServiceBindingsList* = Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593965(
    name: "servicebrokerProjectsBrokersInstancesServiceBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_bindings", validator: validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593966,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_593967,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersServiceInstancesList_593986 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersServiceInstancesList_593988(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersServiceInstancesList_593987(
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
  var valid_593989 = path.getOrDefault("parent")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "parent", valid_593989
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
  var valid_593990 = query.getOrDefault("upload_protocol")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "upload_protocol", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("pageToken")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "pageToken", valid_593992
  var valid_593993 = query.getOrDefault("quotaUser")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "quotaUser", valid_593993
  var valid_593994 = query.getOrDefault("alt")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = newJString("json"))
  if valid_593994 != nil:
    section.add "alt", valid_593994
  var valid_593995 = query.getOrDefault("oauth_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "oauth_token", valid_593995
  var valid_593996 = query.getOrDefault("callback")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "callback", valid_593996
  var valid_593997 = query.getOrDefault("access_token")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "access_token", valid_593997
  var valid_593998 = query.getOrDefault("uploadType")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "uploadType", valid_593998
  var valid_593999 = query.getOrDefault("key")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "key", valid_593999
  var valid_594000 = query.getOrDefault("$.xgafv")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("1"))
  if valid_594000 != nil:
    section.add "$.xgafv", valid_594000
  var valid_594001 = query.getOrDefault("pageSize")
  valid_594001 = validateParameter(valid_594001, JInt, required = false, default = nil)
  if valid_594001 != nil:
    section.add "pageSize", valid_594001
  var valid_594002 = query.getOrDefault("prettyPrint")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(true))
  if valid_594002 != nil:
    section.add "prettyPrint", valid_594002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594003: Call_ServicebrokerProjectsBrokersServiceInstancesList_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_594003.validator(path, query, header, formData, body)
  let scheme = call_594003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594003.url(scheme.get, call_594003.host, call_594003.base,
                         call_594003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594003, url, valid)

proc call*(call_594004: Call_ServicebrokerProjectsBrokersServiceInstancesList_593986;
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
  var path_594005 = newJObject()
  var query_594006 = newJObject()
  add(query_594006, "upload_protocol", newJString(uploadProtocol))
  add(query_594006, "fields", newJString(fields))
  add(query_594006, "pageToken", newJString(pageToken))
  add(query_594006, "quotaUser", newJString(quotaUser))
  add(query_594006, "alt", newJString(alt))
  add(query_594006, "oauth_token", newJString(oauthToken))
  add(query_594006, "callback", newJString(callback))
  add(query_594006, "access_token", newJString(accessToken))
  add(query_594006, "uploadType", newJString(uploadType))
  add(path_594005, "parent", newJString(parent))
  add(query_594006, "key", newJString(key))
  add(query_594006, "$.xgafv", newJString(Xgafv))
  add(query_594006, "pageSize", newJInt(pageSize))
  add(query_594006, "prettyPrint", newJBool(prettyPrint))
  result = call_594004.call(path_594005, query_594006, nil, nil, nil)

var servicebrokerProjectsBrokersServiceInstancesList* = Call_ServicebrokerProjectsBrokersServiceInstancesList_593986(
    name: "servicebrokerProjectsBrokersServiceInstancesList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_instances",
    validator: validate_ServicebrokerProjectsBrokersServiceInstancesList_593987,
    base: "/", url: url_ServicebrokerProjectsBrokersServiceInstancesList_593988,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_594007 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2CatalogList_594009(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2CatalogList_594008(path: JsonNode;
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
  var valid_594010 = path.getOrDefault("parent")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "parent", valid_594010
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
  var valid_594011 = query.getOrDefault("upload_protocol")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "upload_protocol", valid_594011
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("pageToken")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "pageToken", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("callback")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "callback", valid_594017
  var valid_594018 = query.getOrDefault("access_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "access_token", valid_594018
  var valid_594019 = query.getOrDefault("uploadType")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "uploadType", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("$.xgafv")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("1"))
  if valid_594021 != nil:
    section.add "$.xgafv", valid_594021
  var valid_594022 = query.getOrDefault("pageSize")
  valid_594022 = validateParameter(valid_594022, JInt, required = false, default = nil)
  if valid_594022 != nil:
    section.add "pageSize", valid_594022
  var valid_594023 = query.getOrDefault("prettyPrint")
  valid_594023 = validateParameter(valid_594023, JBool, required = false,
                                 default = newJBool(true))
  if valid_594023 != nil:
    section.add "prettyPrint", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_ServicebrokerProjectsBrokersV2CatalogList_594007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_ServicebrokerProjectsBrokersV2CatalogList_594007;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "upload_protocol", newJString(uploadProtocol))
  add(query_594027, "fields", newJString(fields))
  add(query_594027, "pageToken", newJString(pageToken))
  add(query_594027, "quotaUser", newJString(quotaUser))
  add(query_594027, "alt", newJString(alt))
  add(query_594027, "oauth_token", newJString(oauthToken))
  add(query_594027, "callback", newJString(callback))
  add(query_594027, "access_token", newJString(accessToken))
  add(query_594027, "uploadType", newJString(uploadType))
  add(path_594026, "parent", newJString(parent))
  add(query_594027, "key", newJString(key))
  add(query_594027, "$.xgafv", newJString(Xgafv))
  add(query_594027, "pageSize", newJInt(pageSize))
  add(query_594027, "prettyPrint", newJBool(prettyPrint))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_594007(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_594008,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_594009,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594028 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594030(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594029(
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
  var valid_594031 = path.getOrDefault("parent")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "parent", valid_594031
  var valid_594032 = path.getOrDefault("instanceId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "instanceId", valid_594032
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
  var valid_594033 = query.getOrDefault("upload_protocol")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "upload_protocol", valid_594033
  var valid_594034 = query.getOrDefault("fields")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "fields", valid_594034
  var valid_594035 = query.getOrDefault("quotaUser")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "quotaUser", valid_594035
  var valid_594036 = query.getOrDefault("alt")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("json"))
  if valid_594036 != nil:
    section.add "alt", valid_594036
  var valid_594037 = query.getOrDefault("acceptsIncomplete")
  valid_594037 = validateParameter(valid_594037, JBool, required = false, default = nil)
  if valid_594037 != nil:
    section.add "acceptsIncomplete", valid_594037
  var valid_594038 = query.getOrDefault("oauth_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "oauth_token", valid_594038
  var valid_594039 = query.getOrDefault("callback")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "callback", valid_594039
  var valid_594040 = query.getOrDefault("access_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "access_token", valid_594040
  var valid_594041 = query.getOrDefault("uploadType")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "uploadType", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("$.xgafv")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = newJString("1"))
  if valid_594043 != nil:
    section.add "$.xgafv", valid_594043
  var valid_594044 = query.getOrDefault("planId")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "planId", valid_594044
  var valid_594045 = query.getOrDefault("prettyPrint")
  valid_594045 = validateParameter(valid_594045, JBool, required = false,
                                 default = newJBool(true))
  if valid_594045 != nil:
    section.add "prettyPrint", valid_594045
  var valid_594046 = query.getOrDefault("serviceId")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "serviceId", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594028;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "upload_protocol", newJString(uploadProtocol))
  add(query_594050, "fields", newJString(fields))
  add(query_594050, "quotaUser", newJString(quotaUser))
  add(query_594050, "alt", newJString(alt))
  add(query_594050, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_594050, "oauth_token", newJString(oauthToken))
  add(query_594050, "callback", newJString(callback))
  add(query_594050, "access_token", newJString(accessToken))
  add(query_594050, "uploadType", newJString(uploadType))
  add(path_594049, "parent", newJString(parent))
  add(path_594049, "instanceId", newJString(instanceId))
  add(query_594050, "key", newJString(key))
  add(query_594050, "$.xgafv", newJString(Xgafv))
  add(query_594050, "planId", newJString(planId))
  add(query_594050, "prettyPrint", newJBool(prettyPrint))
  add(query_594050, "serviceId", newJString(serviceId))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594028(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594029,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_594030,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594051 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594053(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594052(
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
  var valid_594054 = path.getOrDefault("parent")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "parent", valid_594054
  var valid_594055 = path.getOrDefault("instanceId")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "instanceId", valid_594055
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
  var valid_594056 = query.getOrDefault("upload_protocol")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "upload_protocol", valid_594056
  var valid_594057 = query.getOrDefault("fields")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "fields", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("callback")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "callback", valid_594061
  var valid_594062 = query.getOrDefault("access_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "access_token", valid_594062
  var valid_594063 = query.getOrDefault("uploadType")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "uploadType", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("$.xgafv")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("1"))
  if valid_594065 != nil:
    section.add "$.xgafv", valid_594065
  var valid_594066 = query.getOrDefault("planId")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "planId", valid_594066
  var valid_594067 = query.getOrDefault("operation")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "operation", valid_594067
  var valid_594068 = query.getOrDefault("prettyPrint")
  valid_594068 = validateParameter(valid_594068, JBool, required = false,
                                 default = newJBool(true))
  if valid_594068 != nil:
    section.add "prettyPrint", valid_594068
  var valid_594069 = query.getOrDefault("serviceId")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "serviceId", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594051;
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
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(query_594073, "upload_protocol", newJString(uploadProtocol))
  add(query_594073, "fields", newJString(fields))
  add(query_594073, "quotaUser", newJString(quotaUser))
  add(query_594073, "alt", newJString(alt))
  add(query_594073, "oauth_token", newJString(oauthToken))
  add(query_594073, "callback", newJString(callback))
  add(query_594073, "access_token", newJString(accessToken))
  add(query_594073, "uploadType", newJString(uploadType))
  add(path_594072, "parent", newJString(parent))
  add(path_594072, "instanceId", newJString(instanceId))
  add(query_594073, "key", newJString(key))
  add(query_594073, "$.xgafv", newJString(Xgafv))
  add(query_594073, "planId", newJString(planId))
  add(query_594073, "operation", newJString(operation))
  add(query_594073, "prettyPrint", newJBool(prettyPrint))
  add(query_594073, "serviceId", newJString(serviceId))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594051(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594052,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_594053,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594074 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594076(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594075(
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
  var valid_594077 = path.getOrDefault("parent")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "parent", valid_594077
  var valid_594078 = path.getOrDefault("instanceId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "instanceId", valid_594078
  var valid_594079 = path.getOrDefault("bindingId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "bindingId", valid_594079
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
  var valid_594080 = query.getOrDefault("upload_protocol")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "upload_protocol", valid_594080
  var valid_594081 = query.getOrDefault("fields")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "fields", valid_594081
  var valid_594082 = query.getOrDefault("quotaUser")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "quotaUser", valid_594082
  var valid_594083 = query.getOrDefault("alt")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = newJString("json"))
  if valid_594083 != nil:
    section.add "alt", valid_594083
  var valid_594084 = query.getOrDefault("oauth_token")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "oauth_token", valid_594084
  var valid_594085 = query.getOrDefault("callback")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "callback", valid_594085
  var valid_594086 = query.getOrDefault("access_token")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "access_token", valid_594086
  var valid_594087 = query.getOrDefault("uploadType")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "uploadType", valid_594087
  var valid_594088 = query.getOrDefault("key")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "key", valid_594088
  var valid_594089 = query.getOrDefault("$.xgafv")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("1"))
  if valid_594089 != nil:
    section.add "$.xgafv", valid_594089
  var valid_594090 = query.getOrDefault("planId")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "planId", valid_594090
  var valid_594091 = query.getOrDefault("prettyPrint")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "prettyPrint", valid_594091
  var valid_594092 = query.getOrDefault("serviceId")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "serviceId", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594074;
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(query_594096, "upload_protocol", newJString(uploadProtocol))
  add(query_594096, "fields", newJString(fields))
  add(query_594096, "quotaUser", newJString(quotaUser))
  add(query_594096, "alt", newJString(alt))
  add(query_594096, "oauth_token", newJString(oauthToken))
  add(query_594096, "callback", newJString(callback))
  add(query_594096, "access_token", newJString(accessToken))
  add(query_594096, "uploadType", newJString(uploadType))
  add(path_594095, "parent", newJString(parent))
  add(path_594095, "instanceId", newJString(instanceId))
  add(query_594096, "key", newJString(key))
  add(query_594096, "$.xgafv", newJString(Xgafv))
  add(query_594096, "planId", newJString(planId))
  add(query_594096, "prettyPrint", newJBool(prettyPrint))
  add(query_594096, "serviceId", newJString(serviceId))
  add(path_594095, "bindingId", newJString(bindingId))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594074(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594075,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_594076,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594097 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594099(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594098(
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
  var valid_594100 = path.getOrDefault("parent")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "parent", valid_594100
  var valid_594101 = path.getOrDefault("instanceId")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "instanceId", valid_594101
  var valid_594102 = path.getOrDefault("bindingId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "bindingId", valid_594102
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
  var valid_594103 = query.getOrDefault("upload_protocol")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "upload_protocol", valid_594103
  var valid_594104 = query.getOrDefault("fields")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "fields", valid_594104
  var valid_594105 = query.getOrDefault("quotaUser")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "quotaUser", valid_594105
  var valid_594106 = query.getOrDefault("alt")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("json"))
  if valid_594106 != nil:
    section.add "alt", valid_594106
  var valid_594107 = query.getOrDefault("oauth_token")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "oauth_token", valid_594107
  var valid_594108 = query.getOrDefault("callback")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "callback", valid_594108
  var valid_594109 = query.getOrDefault("access_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "access_token", valid_594109
  var valid_594110 = query.getOrDefault("uploadType")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "uploadType", valid_594110
  var valid_594111 = query.getOrDefault("key")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "key", valid_594111
  var valid_594112 = query.getOrDefault("$.xgafv")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("1"))
  if valid_594112 != nil:
    section.add "$.xgafv", valid_594112
  var valid_594113 = query.getOrDefault("planId")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "planId", valid_594113
  var valid_594114 = query.getOrDefault("operation")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "operation", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
  var valid_594116 = query.getOrDefault("serviceId")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "serviceId", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594097;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  add(query_594120, "upload_protocol", newJString(uploadProtocol))
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "callback", newJString(callback))
  add(query_594120, "access_token", newJString(accessToken))
  add(query_594120, "uploadType", newJString(uploadType))
  add(path_594119, "parent", newJString(parent))
  add(path_594119, "instanceId", newJString(instanceId))
  add(query_594120, "key", newJString(key))
  add(query_594120, "$.xgafv", newJString(Xgafv))
  add(query_594120, "planId", newJString(planId))
  add(query_594120, "operation", newJString(operation))
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  add(query_594120, "serviceId", newJString(serviceId))
  add(path_594119, "bindingId", newJString(bindingId))
  result = call_594118.call(path_594119, query_594120, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594097(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594098,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_594099,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594121 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594123(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594122(
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
  var valid_594124 = path.getOrDefault("parent")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "parent", valid_594124
  var valid_594125 = path.getOrDefault("instanceId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "instanceId", valid_594125
  var valid_594126 = path.getOrDefault("binding_id")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "binding_id", valid_594126
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
  var valid_594127 = query.getOrDefault("upload_protocol")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "upload_protocol", valid_594127
  var valid_594128 = query.getOrDefault("fields")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "fields", valid_594128
  var valid_594129 = query.getOrDefault("quotaUser")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "quotaUser", valid_594129
  var valid_594130 = query.getOrDefault("alt")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("json"))
  if valid_594130 != nil:
    section.add "alt", valid_594130
  var valid_594131 = query.getOrDefault("acceptsIncomplete")
  valid_594131 = validateParameter(valid_594131, JBool, required = false, default = nil)
  if valid_594131 != nil:
    section.add "acceptsIncomplete", valid_594131
  var valid_594132 = query.getOrDefault("oauth_token")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "oauth_token", valid_594132
  var valid_594133 = query.getOrDefault("callback")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "callback", valid_594133
  var valid_594134 = query.getOrDefault("access_token")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "access_token", valid_594134
  var valid_594135 = query.getOrDefault("uploadType")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "uploadType", valid_594135
  var valid_594136 = query.getOrDefault("key")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "key", valid_594136
  var valid_594137 = query.getOrDefault("$.xgafv")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = newJString("1"))
  if valid_594137 != nil:
    section.add "$.xgafv", valid_594137
  var valid_594138 = query.getOrDefault("prettyPrint")
  valid_594138 = validateParameter(valid_594138, JBool, required = false,
                                 default = newJBool(true))
  if valid_594138 != nil:
    section.add "prettyPrint", valid_594138
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

proc call*(call_594140: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594121;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  var body_594144 = newJObject()
  add(query_594143, "upload_protocol", newJString(uploadProtocol))
  add(query_594143, "fields", newJString(fields))
  add(query_594143, "quotaUser", newJString(quotaUser))
  add(query_594143, "alt", newJString(alt))
  add(query_594143, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_594143, "oauth_token", newJString(oauthToken))
  add(query_594143, "callback", newJString(callback))
  add(query_594143, "access_token", newJString(accessToken))
  add(query_594143, "uploadType", newJString(uploadType))
  add(path_594142, "parent", newJString(parent))
  add(path_594142, "instanceId", newJString(instanceId))
  add(query_594143, "key", newJString(key))
  add(query_594143, "$.xgafv", newJString(Xgafv))
  add(path_594142, "binding_id", newJString(bindingId))
  if body != nil:
    body_594144 = body
  add(query_594143, "prettyPrint", newJBool(prettyPrint))
  result = call_594141.call(path_594142, query_594143, nil, nil, body_594144)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594121(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594122,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_594123,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594145 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594147(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594146(
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
  var valid_594148 = path.getOrDefault("parent")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "parent", valid_594148
  var valid_594149 = path.getOrDefault("instance_id")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "instance_id", valid_594149
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
  var valid_594150 = query.getOrDefault("upload_protocol")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "upload_protocol", valid_594150
  var valid_594151 = query.getOrDefault("fields")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "fields", valid_594151
  var valid_594152 = query.getOrDefault("quotaUser")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "quotaUser", valid_594152
  var valid_594153 = query.getOrDefault("alt")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = newJString("json"))
  if valid_594153 != nil:
    section.add "alt", valid_594153
  var valid_594154 = query.getOrDefault("acceptsIncomplete")
  valid_594154 = validateParameter(valid_594154, JBool, required = false, default = nil)
  if valid_594154 != nil:
    section.add "acceptsIncomplete", valid_594154
  var valid_594155 = query.getOrDefault("oauth_token")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "oauth_token", valid_594155
  var valid_594156 = query.getOrDefault("callback")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "callback", valid_594156
  var valid_594157 = query.getOrDefault("access_token")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "access_token", valid_594157
  var valid_594158 = query.getOrDefault("uploadType")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "uploadType", valid_594158
  var valid_594159 = query.getOrDefault("key")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "key", valid_594159
  var valid_594160 = query.getOrDefault("$.xgafv")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = newJString("1"))
  if valid_594160 != nil:
    section.add "$.xgafv", valid_594160
  var valid_594161 = query.getOrDefault("prettyPrint")
  valid_594161 = validateParameter(valid_594161, JBool, required = false,
                                 default = newJBool(true))
  if valid_594161 != nil:
    section.add "prettyPrint", valid_594161
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

proc call*(call_594163: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594145;
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
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594145;
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
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  var body_594167 = newJObject()
  add(query_594166, "upload_protocol", newJString(uploadProtocol))
  add(query_594166, "fields", newJString(fields))
  add(query_594166, "quotaUser", newJString(quotaUser))
  add(query_594166, "alt", newJString(alt))
  add(query_594166, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_594166, "oauth_token", newJString(oauthToken))
  add(query_594166, "callback", newJString(callback))
  add(query_594166, "access_token", newJString(accessToken))
  add(query_594166, "uploadType", newJString(uploadType))
  add(path_594165, "parent", newJString(parent))
  add(query_594166, "key", newJString(key))
  add(query_594166, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594167 = body
  add(query_594166, "prettyPrint", newJBool(prettyPrint))
  add(path_594165, "instance_id", newJString(instanceId))
  result = call_594164.call(path_594165, query_594166, nil, nil, body_594167)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594145(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594146,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_594147,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594168 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594170(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594169(
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
  var valid_594171 = path.getOrDefault("parent")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "parent", valid_594171
  var valid_594172 = path.getOrDefault("instance_id")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "instance_id", valid_594172
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
  var valid_594173 = query.getOrDefault("upload_protocol")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "upload_protocol", valid_594173
  var valid_594174 = query.getOrDefault("fields")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "fields", valid_594174
  var valid_594175 = query.getOrDefault("quotaUser")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "quotaUser", valid_594175
  var valid_594176 = query.getOrDefault("alt")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = newJString("json"))
  if valid_594176 != nil:
    section.add "alt", valid_594176
  var valid_594177 = query.getOrDefault("acceptsIncomplete")
  valid_594177 = validateParameter(valid_594177, JBool, required = false, default = nil)
  if valid_594177 != nil:
    section.add "acceptsIncomplete", valid_594177
  var valid_594178 = query.getOrDefault("oauth_token")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "oauth_token", valid_594178
  var valid_594179 = query.getOrDefault("callback")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "callback", valid_594179
  var valid_594180 = query.getOrDefault("access_token")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "access_token", valid_594180
  var valid_594181 = query.getOrDefault("uploadType")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "uploadType", valid_594181
  var valid_594182 = query.getOrDefault("key")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "key", valid_594182
  var valid_594183 = query.getOrDefault("$.xgafv")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = newJString("1"))
  if valid_594183 != nil:
    section.add "$.xgafv", valid_594183
  var valid_594184 = query.getOrDefault("prettyPrint")
  valid_594184 = validateParameter(valid_594184, JBool, required = false,
                                 default = newJBool(true))
  if valid_594184 != nil:
    section.add "prettyPrint", valid_594184
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

proc call*(call_594186: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594168;
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
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  var body_594190 = newJObject()
  add(query_594189, "upload_protocol", newJString(uploadProtocol))
  add(query_594189, "fields", newJString(fields))
  add(query_594189, "quotaUser", newJString(quotaUser))
  add(query_594189, "alt", newJString(alt))
  add(query_594189, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_594189, "oauth_token", newJString(oauthToken))
  add(query_594189, "callback", newJString(callback))
  add(query_594189, "access_token", newJString(accessToken))
  add(query_594189, "uploadType", newJString(uploadType))
  add(path_594188, "parent", newJString(parent))
  add(query_594189, "key", newJString(key))
  add(query_594189, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594190 = body
  add(query_594189, "prettyPrint", newJBool(prettyPrint))
  add(path_594188, "instance_id", newJString(instanceId))
  result = call_594187.call(path_594188, query_594189, nil, nil, body_594190)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594168(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594169,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_594170,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_594191 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerGetIamPolicy_594193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerGetIamPolicy_594192(path: JsonNode; query: JsonNode;
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
  var valid_594194 = path.getOrDefault("resource")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "resource", valid_594194
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
  var valid_594195 = query.getOrDefault("upload_protocol")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "upload_protocol", valid_594195
  var valid_594196 = query.getOrDefault("fields")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "fields", valid_594196
  var valid_594197 = query.getOrDefault("quotaUser")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "quotaUser", valid_594197
  var valid_594198 = query.getOrDefault("alt")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("json"))
  if valid_594198 != nil:
    section.add "alt", valid_594198
  var valid_594199 = query.getOrDefault("oauth_token")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "oauth_token", valid_594199
  var valid_594200 = query.getOrDefault("callback")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "callback", valid_594200
  var valid_594201 = query.getOrDefault("access_token")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "access_token", valid_594201
  var valid_594202 = query.getOrDefault("uploadType")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "uploadType", valid_594202
  var valid_594203 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594203 = validateParameter(valid_594203, JInt, required = false, default = nil)
  if valid_594203 != nil:
    section.add "options.requestedPolicyVersion", valid_594203
  var valid_594204 = query.getOrDefault("key")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "key", valid_594204
  var valid_594205 = query.getOrDefault("$.xgafv")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = newJString("1"))
  if valid_594205 != nil:
    section.add "$.xgafv", valid_594205
  var valid_594206 = query.getOrDefault("prettyPrint")
  valid_594206 = validateParameter(valid_594206, JBool, required = false,
                                 default = newJBool(true))
  if valid_594206 != nil:
    section.add "prettyPrint", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_ServicebrokerGetIamPolicy_594191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_ServicebrokerGetIamPolicy_594191; resource: string;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(query_594210, "upload_protocol", newJString(uploadProtocol))
  add(query_594210, "fields", newJString(fields))
  add(query_594210, "quotaUser", newJString(quotaUser))
  add(query_594210, "alt", newJString(alt))
  add(query_594210, "oauth_token", newJString(oauthToken))
  add(query_594210, "callback", newJString(callback))
  add(query_594210, "access_token", newJString(accessToken))
  add(query_594210, "uploadType", newJString(uploadType))
  add(query_594210, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594210, "key", newJString(key))
  add(query_594210, "$.xgafv", newJString(Xgafv))
  add(path_594209, "resource", newJString(resource))
  add(query_594210, "prettyPrint", newJBool(prettyPrint))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_594191(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_594192, base: "/",
    url: url_ServicebrokerGetIamPolicy_594193, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_594211 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerSetIamPolicy_594213(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerSetIamPolicy_594212(path: JsonNode; query: JsonNode;
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
  var valid_594214 = path.getOrDefault("resource")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resource", valid_594214
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
  var valid_594215 = query.getOrDefault("upload_protocol")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "upload_protocol", valid_594215
  var valid_594216 = query.getOrDefault("fields")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "fields", valid_594216
  var valid_594217 = query.getOrDefault("quotaUser")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "quotaUser", valid_594217
  var valid_594218 = query.getOrDefault("alt")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("json"))
  if valid_594218 != nil:
    section.add "alt", valid_594218
  var valid_594219 = query.getOrDefault("oauth_token")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "oauth_token", valid_594219
  var valid_594220 = query.getOrDefault("callback")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "callback", valid_594220
  var valid_594221 = query.getOrDefault("access_token")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "access_token", valid_594221
  var valid_594222 = query.getOrDefault("uploadType")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "uploadType", valid_594222
  var valid_594223 = query.getOrDefault("key")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "key", valid_594223
  var valid_594224 = query.getOrDefault("$.xgafv")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = newJString("1"))
  if valid_594224 != nil:
    section.add "$.xgafv", valid_594224
  var valid_594225 = query.getOrDefault("prettyPrint")
  valid_594225 = validateParameter(valid_594225, JBool, required = false,
                                 default = newJBool(true))
  if valid_594225 != nil:
    section.add "prettyPrint", valid_594225
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

proc call*(call_594227: Call_ServicebrokerSetIamPolicy_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_594227.validator(path, query, header, formData, body)
  let scheme = call_594227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594227.url(scheme.get, call_594227.host, call_594227.base,
                         call_594227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594227, url, valid)

proc call*(call_594228: Call_ServicebrokerSetIamPolicy_594211; resource: string;
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
  var path_594229 = newJObject()
  var query_594230 = newJObject()
  var body_594231 = newJObject()
  add(query_594230, "upload_protocol", newJString(uploadProtocol))
  add(query_594230, "fields", newJString(fields))
  add(query_594230, "quotaUser", newJString(quotaUser))
  add(query_594230, "alt", newJString(alt))
  add(query_594230, "oauth_token", newJString(oauthToken))
  add(query_594230, "callback", newJString(callback))
  add(query_594230, "access_token", newJString(accessToken))
  add(query_594230, "uploadType", newJString(uploadType))
  add(query_594230, "key", newJString(key))
  add(query_594230, "$.xgafv", newJString(Xgafv))
  add(path_594229, "resource", newJString(resource))
  if body != nil:
    body_594231 = body
  add(query_594230, "prettyPrint", newJBool(prettyPrint))
  result = call_594228.call(path_594229, query_594230, nil, nil, body_594231)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_594211(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_594212, base: "/",
    url: url_ServicebrokerSetIamPolicy_594213, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_594232 = ref object of OpenApiRestCall_593408
proc url_ServicebrokerTestIamPermissions_594234(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicebrokerTestIamPermissions_594233(path: JsonNode;
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
  var valid_594235 = path.getOrDefault("resource")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "resource", valid_594235
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
  var valid_594236 = query.getOrDefault("upload_protocol")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "upload_protocol", valid_594236
  var valid_594237 = query.getOrDefault("fields")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "fields", valid_594237
  var valid_594238 = query.getOrDefault("quotaUser")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "quotaUser", valid_594238
  var valid_594239 = query.getOrDefault("alt")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = newJString("json"))
  if valid_594239 != nil:
    section.add "alt", valid_594239
  var valid_594240 = query.getOrDefault("oauth_token")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "oauth_token", valid_594240
  var valid_594241 = query.getOrDefault("callback")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "callback", valid_594241
  var valid_594242 = query.getOrDefault("access_token")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "access_token", valid_594242
  var valid_594243 = query.getOrDefault("uploadType")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "uploadType", valid_594243
  var valid_594244 = query.getOrDefault("key")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "key", valid_594244
  var valid_594245 = query.getOrDefault("$.xgafv")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = newJString("1"))
  if valid_594245 != nil:
    section.add "$.xgafv", valid_594245
  var valid_594246 = query.getOrDefault("prettyPrint")
  valid_594246 = validateParameter(valid_594246, JBool, required = false,
                                 default = newJBool(true))
  if valid_594246 != nil:
    section.add "prettyPrint", valid_594246
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

proc call*(call_594248: Call_ServicebrokerTestIamPermissions_594232;
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
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_ServicebrokerTestIamPermissions_594232;
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
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  var body_594252 = newJObject()
  add(query_594251, "upload_protocol", newJString(uploadProtocol))
  add(query_594251, "fields", newJString(fields))
  add(query_594251, "quotaUser", newJString(quotaUser))
  add(query_594251, "alt", newJString(alt))
  add(query_594251, "oauth_token", newJString(oauthToken))
  add(query_594251, "callback", newJString(callback))
  add(query_594251, "access_token", newJString(accessToken))
  add(query_594251, "uploadType", newJString(uploadType))
  add(query_594251, "key", newJString(key))
  add(query_594251, "$.xgafv", newJString(Xgafv))
  add(path_594250, "resource", newJString(resource))
  if body != nil:
    body_594252 = body
  add(query_594251, "prettyPrint", newJBool(prettyPrint))
  result = call_594249.call(path_594250, query_594251, nil, nil, body_594252)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_594232(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_594233, base: "/",
    url: url_ServicebrokerTestIamPermissions_594234, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
