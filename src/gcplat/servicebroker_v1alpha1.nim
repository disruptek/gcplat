
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578610 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578612(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578611(
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

proc call*(call_578785: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesGet
  ## Gets the given service instance from the system.
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
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
  ##       : The resource name of the instance to return.
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

var servicebrokerProjectsBrokersV2ServiceInstancesGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578610(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578611,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGet_578612,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578898 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578900(
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

proc validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578899(
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
  var valid_578901 = path.getOrDefault("parent")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "parent", valid_578901
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  var valid_578906 = query.getOrDefault("pageSize")
  valid_578906 = validateParameter(valid_578906, JInt, required = false, default = nil)
  if valid_578906 != nil:
    section.add "pageSize", valid_578906
  var valid_578907 = query.getOrDefault("alt")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("json"))
  if valid_578907 != nil:
    section.add "alt", valid_578907
  var valid_578908 = query.getOrDefault("uploadType")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "uploadType", valid_578908
  var valid_578909 = query.getOrDefault("quotaUser")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "quotaUser", valid_578909
  var valid_578910 = query.getOrDefault("pageToken")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "pageToken", valid_578910
  var valid_578911 = query.getOrDefault("callback")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "callback", valid_578911
  var valid_578912 = query.getOrDefault("fields")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "fields", valid_578912
  var valid_578913 = query.getOrDefault("access_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "access_token", valid_578913
  var valid_578914 = query.getOrDefault("upload_protocol")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "upload_protocol", valid_578914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578915: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance
  ## 
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578898;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersInstancesServiceBindingsList
  ## Lists all the bindings in the instance
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(query_578918, "pageSize", newJInt(pageSize))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "pageToken", newJString(pageToken))
  add(query_578918, "callback", newJString(callback))
  add(path_578917, "parent", newJString(parent))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  result = call_578916.call(path_578917, query_578918, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesServiceBindingsList* = Call_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578898(
    name: "servicebrokerProjectsBrokersInstancesServiceBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_bindings", validator: validate_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578899,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesServiceBindingsList_578900,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersServiceInstancesList_578919 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersServiceInstancesList_578921(
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

proc validate_ServicebrokerProjectsBrokersServiceInstancesList_578920(
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
  var valid_578922 = path.getOrDefault("parent")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "parent", valid_578922
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("$.xgafv")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("1"))
  if valid_578926 != nil:
    section.add "$.xgafv", valid_578926
  var valid_578927 = query.getOrDefault("pageSize")
  valid_578927 = validateParameter(valid_578927, JInt, required = false, default = nil)
  if valid_578927 != nil:
    section.add "pageSize", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("uploadType")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "uploadType", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("pageToken")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "pageToken", valid_578931
  var valid_578932 = query.getOrDefault("callback")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "callback", valid_578932
  var valid_578933 = query.getOrDefault("fields")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "fields", valid_578933
  var valid_578934 = query.getOrDefault("access_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "access_token", valid_578934
  var valid_578935 = query.getOrDefault("upload_protocol")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "upload_protocol", valid_578935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578936: Call_ServicebrokerProjectsBrokersServiceInstancesList_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_ServicebrokerProjectsBrokersServiceInstancesList_578919;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersServiceInstancesList
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "$.xgafv", newJString(Xgafv))
  add(query_578939, "pageSize", newJInt(pageSize))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "uploadType", newJString(uploadType))
  add(query_578939, "quotaUser", newJString(quotaUser))
  add(query_578939, "pageToken", newJString(pageToken))
  add(query_578939, "callback", newJString(callback))
  add(path_578938, "parent", newJString(parent))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "access_token", newJString(accessToken))
  add(query_578939, "upload_protocol", newJString(uploadProtocol))
  result = call_578937.call(path_578938, query_578939, nil, nil, nil)

var servicebrokerProjectsBrokersServiceInstancesList* = Call_ServicebrokerProjectsBrokersServiceInstancesList_578919(
    name: "servicebrokerProjectsBrokersServiceInstancesList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/service_instances",
    validator: validate_ServicebrokerProjectsBrokersServiceInstancesList_578920,
    base: "/", url: url_ServicebrokerProjectsBrokersServiceInstancesList_578921,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_578940 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2CatalogList_578942(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersV2CatalogList_578941(path: JsonNode;
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
  var valid_578943 = path.getOrDefault("parent")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "parent", valid_578943
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("pageSize")
  valid_578948 = validateParameter(valid_578948, JInt, required = false, default = nil)
  if valid_578948 != nil:
    section.add "pageSize", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("pageToken")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "pageToken", valid_578952
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

proc call*(call_578957: Call_ServicebrokerProjectsBrokersV2CatalogList_578940;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_ServicebrokerProjectsBrokersV2CatalogList_578940;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2CatalogList
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
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
  add(query_578960, "pageSize", newJInt(pageSize))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(query_578960, "pageToken", newJString(pageToken))
  add(query_578960, "callback", newJString(callback))
  add(path_578959, "parent", newJString(parent))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(path_578959, query_578960, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_578940(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_578941,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_578942,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578961 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578963(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578962(
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
  var valid_578964 = path.getOrDefault("parent")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "parent", valid_578964
  var valid_578965 = path.getOrDefault("instanceId")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "instanceId", valid_578965
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : The service id of the service instance.
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   planId: JString
  ##         : The plan id of the service instance.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("serviceId")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "serviceId", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("$.xgafv")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("1"))
  if valid_578970 != nil:
    section.add "$.xgafv", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("uploadType")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "uploadType", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("acceptsIncomplete")
  valid_578974 = validateParameter(valid_578974, JBool, required = false, default = nil)
  if valid_578974 != nil:
    section.add "acceptsIncomplete", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("planId")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "planId", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
  var valid_578978 = query.getOrDefault("access_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "access_token", valid_578978
  var valid_578979 = query.getOrDefault("upload_protocol")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "upload_protocol", valid_578979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578980: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_578980.validator(path, query, header, formData, body)
  let scheme = call_578980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578980.url(scheme.get, call_578980.host, call_578980.base,
                         call_578980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578980, url, valid)

proc call*(call_578981: Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578961;
          parent: string; instanceId: string; key: string = ""; serviceId: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; callback: string = ""; planId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesDelete
  ## Deprovisions a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If service instance does not exist HTTP 410 status will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : The service id of the service instance.
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
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   planId: string
  ##         : The plan id of the service instance.
  ##   instanceId: string (required)
  ##             : The instance id to deprovision.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578982 = newJObject()
  var query_578983 = newJObject()
  add(query_578983, "key", newJString(key))
  add(query_578983, "serviceId", newJString(serviceId))
  add(query_578983, "prettyPrint", newJBool(prettyPrint))
  add(query_578983, "oauth_token", newJString(oauthToken))
  add(query_578983, "$.xgafv", newJString(Xgafv))
  add(query_578983, "alt", newJString(alt))
  add(query_578983, "uploadType", newJString(uploadType))
  add(query_578983, "quotaUser", newJString(quotaUser))
  add(query_578983, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_578983, "callback", newJString(callback))
  add(path_578982, "parent", newJString(parent))
  add(query_578983, "planId", newJString(planId))
  add(path_578982, "instanceId", newJString(instanceId))
  add(query_578983, "fields", newJString(fields))
  add(query_578983, "access_token", newJString(accessToken))
  add(query_578983, "upload_protocol", newJString(uploadProtocol))
  result = call_578981.call(path_578982, query_578983, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578961(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578962,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesDelete_578963,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578984 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578986(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578985(
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
  var valid_578987 = path.getOrDefault("parent")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "parent", valid_578987
  var valid_578988 = path.getOrDefault("instanceId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "instanceId", valid_578988
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Service id.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   planId: JString
  ##         : Plan id.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578989 = query.getOrDefault("key")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "key", valid_578989
  var valid_578990 = query.getOrDefault("serviceId")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "serviceId", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("operation")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "operation", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("uploadType")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "uploadType", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("callback")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "callback", valid_578998
  var valid_578999 = query.getOrDefault("planId")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "planId", valid_578999
  var valid_579000 = query.getOrDefault("fields")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "fields", valid_579000
  var valid_579001 = query.getOrDefault("access_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "access_token", valid_579001
  var valid_579002 = query.getOrDefault("upload_protocol")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "upload_protocol", valid_579002
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578984;
          parent: string; instanceId: string; key: string = ""; serviceId: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          operation: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; planId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation
  ## Returns the state of the last operation for the service instance.
  ## Only last (or current) operation can be polled.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Service id.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   planId: string
  ##         : Plan id.
  ##   instanceId: string (required)
  ##             : The instance id for which to return the last operation status.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "serviceId", newJString(serviceId))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(query_579006, "$.xgafv", newJString(Xgafv))
  add(query_579006, "operation", newJString(operation))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "uploadType", newJString(uploadType))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(query_579006, "callback", newJString(callback))
  add(path_579005, "parent", newJString(parent))
  add(query_579006, "planId", newJString(planId))
  add(path_579005, "instanceId", newJString(instanceId))
  add(query_579006, "fields", newJString(fields))
  add(query_579006, "access_token", newJString(accessToken))
  add(query_579006, "upload_protocol", newJString(uploadProtocol))
  result = call_579004.call(path_579005, query_579006, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578984(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578985,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesGetLastOperation_578986,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579007 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579009(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579008(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## GetBinding returns the binding information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bindingId: JString (required)
  ##            : The binding id.
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : Instance id to which the binding is bound.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bindingId` field"
  var valid_579010 = path.getOrDefault("bindingId")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "bindingId", valid_579010
  var valid_579011 = path.getOrDefault("parent")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "parent", valid_579011
  var valid_579012 = path.getOrDefault("instanceId")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "instanceId", valid_579012
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Service id.
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
  ##   planId: JString
  ##         : Plan id.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("serviceId")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "serviceId", valid_579014
  var valid_579015 = query.getOrDefault("prettyPrint")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "prettyPrint", valid_579015
  var valid_579016 = query.getOrDefault("oauth_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "oauth_token", valid_579016
  var valid_579017 = query.getOrDefault("$.xgafv")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("1"))
  if valid_579017 != nil:
    section.add "$.xgafv", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("uploadType")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "uploadType", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("callback")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "callback", valid_579021
  var valid_579022 = query.getOrDefault("planId")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "planId", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("access_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "access_token", valid_579024
  var valid_579025 = query.getOrDefault("upload_protocol")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "upload_protocol", valid_579025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579007;
          bindingId: string; parent: string; instanceId: string; key: string = "";
          serviceId: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; planId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet
  ## GetBinding returns the binding information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Service id.
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
  ##   bindingId: string (required)
  ##            : The binding id.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   planId: string
  ##         : Plan id.
  ##   instanceId: string (required)
  ##             : Instance id to which the binding is bound.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "serviceId", newJString(serviceId))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "$.xgafv", newJString(Xgafv))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "uploadType", newJString(uploadType))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "bindingId", newJString(bindingId))
  add(query_579029, "callback", newJString(callback))
  add(path_579028, "parent", newJString(parent))
  add(query_579029, "planId", newJString(planId))
  add(path_579028, "instanceId", newJString(instanceId))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "access_token", newJString(accessToken))
  add(query_579029, "upload_protocol", newJString(uploadProtocol))
  result = call_579027.call(path_579028, query_579029, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579007(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579008,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579009,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579030 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579032(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579031(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bindingId: JString (required)
  ##            : The binding id for which to return the last operation
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The instance id that the binding is bound to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bindingId` field"
  var valid_579033 = path.getOrDefault("bindingId")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "bindingId", valid_579033
  var valid_579034 = path.getOrDefault("parent")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "parent", valid_579034
  var valid_579035 = path.getOrDefault("instanceId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "instanceId", valid_579035
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Service id.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   planId: JString
  ##         : Plan id.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("serviceId")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "serviceId", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("$.xgafv")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("1"))
  if valid_579040 != nil:
    section.add "$.xgafv", valid_579040
  var valid_579041 = query.getOrDefault("operation")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "operation", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("uploadType")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "uploadType", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("callback")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "callback", valid_579045
  var valid_579046 = query.getOrDefault("planId")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "planId", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("access_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "access_token", valid_579048
  var valid_579049 = query.getOrDefault("upload_protocol")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "upload_protocol", valid_579049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579050: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579030;
          bindingId: string; parent: string; instanceId: string; key: string = "";
          serviceId: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; operation: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          planId: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Service id.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   bindingId: string (required)
  ##            : The binding id for which to return the last operation
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   planId: string
  ##         : Plan id.
  ##   instanceId: string (required)
  ##             : The instance id that the binding is bound to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "serviceId", newJString(serviceId))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "$.xgafv", newJString(Xgafv))
  add(query_579053, "operation", newJString(operation))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "uploadType", newJString(uploadType))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(path_579052, "bindingId", newJString(bindingId))
  add(query_579053, "callback", newJString(callback))
  add(path_579052, "parent", newJString(parent))
  add(query_579053, "planId", newJString(planId))
  add(path_579052, "instanceId", newJString(instanceId))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579030(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{bindingId}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579031,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_579032,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579054 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579056(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   binding_id: JString (required)
  ##             : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   parent: JString (required)
  ##         : The GCP container.
  ## Must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: JString (required)
  ##             : The service instance to which to bind.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `binding_id` field"
  var valid_579057 = path.getOrDefault("binding_id")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "binding_id", valid_579057
  var valid_579058 = path.getOrDefault("parent")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "parent", valid_579058
  var valid_579059 = path.getOrDefault("instanceId")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "instanceId", valid_579059
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("acceptsIncomplete")
  valid_579067 = validateParameter(valid_579067, JBool, required = false, default = nil)
  if valid_579067 != nil:
    section.add "acceptsIncomplete", valid_579067
  var valid_579068 = query.getOrDefault("callback")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "callback", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  var valid_579070 = query.getOrDefault("access_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "access_token", valid_579070
  var valid_579071 = query.getOrDefault("upload_protocol")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "upload_protocol", valid_579071
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

proc call*(call_579073: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_579073.validator(path, query, header, formData, body)
  let scheme = call_579073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579073.url(scheme.get, call_579073.host, call_579073.base,
                         call_579073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579073, url, valid)

proc call*(call_579074: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579054;
          bindingId: string; parent: string; instanceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bindingId: string (required)
  ##            : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The GCP container.
  ## Must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instanceId: string (required)
  ##             : The service instance to which to bind.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579075 = newJObject()
  var query_579076 = newJObject()
  var body_579077 = newJObject()
  add(query_579076, "key", newJString(key))
  add(query_579076, "prettyPrint", newJBool(prettyPrint))
  add(query_579076, "oauth_token", newJString(oauthToken))
  add(query_579076, "$.xgafv", newJString(Xgafv))
  add(path_579075, "binding_id", newJString(bindingId))
  add(query_579076, "alt", newJString(alt))
  add(query_579076, "uploadType", newJString(uploadType))
  add(query_579076, "quotaUser", newJString(quotaUser))
  add(query_579076, "acceptsIncomplete", newJBool(acceptsIncomplete))
  if body != nil:
    body_579077 = body
  add(query_579076, "callback", newJString(callback))
  add(path_579075, "parent", newJString(parent))
  add(path_579075, "instanceId", newJString(instanceId))
  add(query_579076, "fields", newJString(fields))
  add(query_579076, "access_token", newJString(accessToken))
  add(query_579076, "upload_protocol", newJString(uploadProtocol))
  result = call_579074.call(path_579075, query_579076, nil, nil, body_579077)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579054(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com", route: "/v1alpha1/{parent}/v2/service_instances/{instanceId}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579055,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579056,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579078 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579080(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579079(
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
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instance_id` field"
  var valid_579081 = path.getOrDefault("instance_id")
  valid_579081 = validateParameter(valid_579081, JString, required = true,
                                 default = nil)
  if valid_579081 != nil:
    section.add "instance_id", valid_579081
  var valid_579082 = path.getOrDefault("parent")
  valid_579082 = validateParameter(valid_579082, JString, required = true,
                                 default = nil)
  if valid_579082 != nil:
    section.add "parent", valid_579082
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
  ##   acceptsIncomplete: JBool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579083 = query.getOrDefault("key")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "key", valid_579083
  var valid_579084 = query.getOrDefault("prettyPrint")
  valid_579084 = validateParameter(valid_579084, JBool, required = false,
                                 default = newJBool(true))
  if valid_579084 != nil:
    section.add "prettyPrint", valid_579084
  var valid_579085 = query.getOrDefault("oauth_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "oauth_token", valid_579085
  var valid_579086 = query.getOrDefault("$.xgafv")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = newJString("1"))
  if valid_579086 != nil:
    section.add "$.xgafv", valid_579086
  var valid_579087 = query.getOrDefault("alt")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("json"))
  if valid_579087 != nil:
    section.add "alt", valid_579087
  var valid_579088 = query.getOrDefault("uploadType")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "uploadType", valid_579088
  var valid_579089 = query.getOrDefault("quotaUser")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "quotaUser", valid_579089
  var valid_579090 = query.getOrDefault("acceptsIncomplete")
  valid_579090 = validateParameter(valid_579090, JBool, required = false, default = nil)
  if valid_579090 != nil:
    section.add "acceptsIncomplete", valid_579090
  var valid_579091 = query.getOrDefault("callback")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "callback", valid_579091
  var valid_579092 = query.getOrDefault("fields")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "fields", valid_579092
  var valid_579093 = query.getOrDefault("access_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "access_token", valid_579093
  var valid_579094 = query.getOrDefault("upload_protocol")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "upload_protocol", valid_579094
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

proc call*(call_579096: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579078;
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
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579078;
          instanceId: string; parent: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   acceptsIncomplete: bool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  var body_579100 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "$.xgafv", newJString(Xgafv))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "uploadType", newJString(uploadType))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(query_579099, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(path_579098, "instance_id", newJString(instanceId))
  if body != nil:
    body_579100 = body
  add(query_579099, "callback", newJString(callback))
  add(path_579098, "parent", newJString(parent))
  add(query_579099, "fields", newJString(fields))
  add(query_579099, "access_token", newJString(accessToken))
  add(query_579099, "upload_protocol", newJString(uploadProtocol))
  result = call_579097.call(path_579098, query_579099, nil, nil, body_579100)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579078(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579079,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579080,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579101 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579103(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instance_id` field"
  var valid_579104 = path.getOrDefault("instance_id")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "instance_id", valid_579104
  var valid_579105 = path.getOrDefault("parent")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "parent", valid_579105
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579106 = query.getOrDefault("key")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "key", valid_579106
  var valid_579107 = query.getOrDefault("prettyPrint")
  valid_579107 = validateParameter(valid_579107, JBool, required = false,
                                 default = newJBool(true))
  if valid_579107 != nil:
    section.add "prettyPrint", valid_579107
  var valid_579108 = query.getOrDefault("oauth_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "oauth_token", valid_579108
  var valid_579109 = query.getOrDefault("$.xgafv")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("1"))
  if valid_579109 != nil:
    section.add "$.xgafv", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("uploadType")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "uploadType", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("acceptsIncomplete")
  valid_579113 = validateParameter(valid_579113, JBool, required = false, default = nil)
  if valid_579113 != nil:
    section.add "acceptsIncomplete", valid_579113
  var valid_579114 = query.getOrDefault("callback")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "callback", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
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

proc call*(call_579119: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_579119.validator(path, query, header, formData, body)
  let scheme = call_579119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579119.url(scheme.get, call_579119.host, call_579119.base,
                         call_579119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579119, url, valid)

proc call*(call_579120: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579101;
          instanceId: string; parent: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesPatch
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
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
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579121 = newJObject()
  var query_579122 = newJObject()
  var body_579123 = newJObject()
  add(query_579122, "key", newJString(key))
  add(query_579122, "prettyPrint", newJBool(prettyPrint))
  add(query_579122, "oauth_token", newJString(oauthToken))
  add(query_579122, "$.xgafv", newJString(Xgafv))
  add(query_579122, "alt", newJString(alt))
  add(query_579122, "uploadType", newJString(uploadType))
  add(query_579122, "quotaUser", newJString(quotaUser))
  add(query_579122, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(path_579121, "instance_id", newJString(instanceId))
  if body != nil:
    body_579123 = body
  add(query_579122, "callback", newJString(callback))
  add(path_579121, "parent", newJString(parent))
  add(query_579122, "fields", newJString(fields))
  add(query_579122, "access_token", newJString(accessToken))
  add(query_579122, "upload_protocol", newJString(uploadProtocol))
  result = call_579120.call(path_579121, query_579122, nil, nil, body_579123)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579101(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579102,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579103,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_579124 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerGetIamPolicy_579126(protocol: Scheme; host: string;
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

proc validate_ServicebrokerGetIamPolicy_579125(path: JsonNode; query: JsonNode;
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
  var valid_579127 = path.getOrDefault("resource")
  valid_579127 = validateParameter(valid_579127, JString, required = true,
                                 default = nil)
  if valid_579127 != nil:
    section.add "resource", valid_579127
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
  var valid_579128 = query.getOrDefault("key")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "key", valid_579128
  var valid_579129 = query.getOrDefault("prettyPrint")
  valid_579129 = validateParameter(valid_579129, JBool, required = false,
                                 default = newJBool(true))
  if valid_579129 != nil:
    section.add "prettyPrint", valid_579129
  var valid_579130 = query.getOrDefault("oauth_token")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "oauth_token", valid_579130
  var valid_579131 = query.getOrDefault("$.xgafv")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("1"))
  if valid_579131 != nil:
    section.add "$.xgafv", valid_579131
  var valid_579132 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579132 = validateParameter(valid_579132, JInt, required = false, default = nil)
  if valid_579132 != nil:
    section.add "options.requestedPolicyVersion", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("uploadType")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "uploadType", valid_579134
  var valid_579135 = query.getOrDefault("quotaUser")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "quotaUser", valid_579135
  var valid_579136 = query.getOrDefault("callback")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "callback", valid_579136
  var valid_579137 = query.getOrDefault("fields")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "fields", valid_579137
  var valid_579138 = query.getOrDefault("access_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "access_token", valid_579138
  var valid_579139 = query.getOrDefault("upload_protocol")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "upload_protocol", valid_579139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579140: Call_ServicebrokerGetIamPolicy_579124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579140.validator(path, query, header, formData, body)
  let scheme = call_579140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579140.url(scheme.get, call_579140.host, call_579140.base,
                         call_579140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579140, url, valid)

proc call*(call_579141: Call_ServicebrokerGetIamPolicy_579124; resource: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; optionsRequestedPolicyVersion: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerGetIamPolicy
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
  var path_579142 = newJObject()
  var query_579143 = newJObject()
  add(query_579143, "key", newJString(key))
  add(query_579143, "prettyPrint", newJBool(prettyPrint))
  add(query_579143, "oauth_token", newJString(oauthToken))
  add(query_579143, "$.xgafv", newJString(Xgafv))
  add(query_579143, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579143, "alt", newJString(alt))
  add(query_579143, "uploadType", newJString(uploadType))
  add(query_579143, "quotaUser", newJString(quotaUser))
  add(path_579142, "resource", newJString(resource))
  add(query_579143, "callback", newJString(callback))
  add(query_579143, "fields", newJString(fields))
  add(query_579143, "access_token", newJString(accessToken))
  add(query_579143, "upload_protocol", newJString(uploadProtocol))
  result = call_579141.call(path_579142, query_579143, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_579124(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_579125, base: "/",
    url: url_ServicebrokerGetIamPolicy_579126, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_579144 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerSetIamPolicy_579146(protocol: Scheme; host: string;
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

proc validate_ServicebrokerSetIamPolicy_579145(path: JsonNode; query: JsonNode;
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
  var valid_579147 = path.getOrDefault("resource")
  valid_579147 = validateParameter(valid_579147, JString, required = true,
                                 default = nil)
  if valid_579147 != nil:
    section.add "resource", valid_579147
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
  var valid_579148 = query.getOrDefault("key")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "key", valid_579148
  var valid_579149 = query.getOrDefault("prettyPrint")
  valid_579149 = validateParameter(valid_579149, JBool, required = false,
                                 default = newJBool(true))
  if valid_579149 != nil:
    section.add "prettyPrint", valid_579149
  var valid_579150 = query.getOrDefault("oauth_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "oauth_token", valid_579150
  var valid_579151 = query.getOrDefault("$.xgafv")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = newJString("1"))
  if valid_579151 != nil:
    section.add "$.xgafv", valid_579151
  var valid_579152 = query.getOrDefault("alt")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = newJString("json"))
  if valid_579152 != nil:
    section.add "alt", valid_579152
  var valid_579153 = query.getOrDefault("uploadType")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "uploadType", valid_579153
  var valid_579154 = query.getOrDefault("quotaUser")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "quotaUser", valid_579154
  var valid_579155 = query.getOrDefault("callback")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "callback", valid_579155
  var valid_579156 = query.getOrDefault("fields")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "fields", valid_579156
  var valid_579157 = query.getOrDefault("access_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "access_token", valid_579157
  var valid_579158 = query.getOrDefault("upload_protocol")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "upload_protocol", valid_579158
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

proc call*(call_579160: Call_ServicebrokerSetIamPolicy_579144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579160.validator(path, query, header, formData, body)
  let scheme = call_579160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579160.url(scheme.get, call_579160.host, call_579160.base,
                         call_579160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579160, url, valid)

proc call*(call_579161: Call_ServicebrokerSetIamPolicy_579144; resource: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerSetIamPolicy
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
  var path_579162 = newJObject()
  var query_579163 = newJObject()
  var body_579164 = newJObject()
  add(query_579163, "key", newJString(key))
  add(query_579163, "prettyPrint", newJBool(prettyPrint))
  add(query_579163, "oauth_token", newJString(oauthToken))
  add(query_579163, "$.xgafv", newJString(Xgafv))
  add(query_579163, "alt", newJString(alt))
  add(query_579163, "uploadType", newJString(uploadType))
  add(query_579163, "quotaUser", newJString(quotaUser))
  add(path_579162, "resource", newJString(resource))
  if body != nil:
    body_579164 = body
  add(query_579163, "callback", newJString(callback))
  add(query_579163, "fields", newJString(fields))
  add(query_579163, "access_token", newJString(accessToken))
  add(query_579163, "upload_protocol", newJString(uploadProtocol))
  result = call_579161.call(path_579162, query_579163, nil, nil, body_579164)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_579144(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_579145, base: "/",
    url: url_ServicebrokerSetIamPolicy_579146, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_579165 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerTestIamPermissions_579167(protocol: Scheme; host: string;
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

proc validate_ServicebrokerTestIamPermissions_579166(path: JsonNode;
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
  var valid_579168 = path.getOrDefault("resource")
  valid_579168 = validateParameter(valid_579168, JString, required = true,
                                 default = nil)
  if valid_579168 != nil:
    section.add "resource", valid_579168
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
  var valid_579169 = query.getOrDefault("key")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "key", valid_579169
  var valid_579170 = query.getOrDefault("prettyPrint")
  valid_579170 = validateParameter(valid_579170, JBool, required = false,
                                 default = newJBool(true))
  if valid_579170 != nil:
    section.add "prettyPrint", valid_579170
  var valid_579171 = query.getOrDefault("oauth_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "oauth_token", valid_579171
  var valid_579172 = query.getOrDefault("$.xgafv")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = newJString("1"))
  if valid_579172 != nil:
    section.add "$.xgafv", valid_579172
  var valid_579173 = query.getOrDefault("alt")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("json"))
  if valid_579173 != nil:
    section.add "alt", valid_579173
  var valid_579174 = query.getOrDefault("uploadType")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "uploadType", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("callback")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "callback", valid_579176
  var valid_579177 = query.getOrDefault("fields")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "fields", valid_579177
  var valid_579178 = query.getOrDefault("access_token")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "access_token", valid_579178
  var valid_579179 = query.getOrDefault("upload_protocol")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "upload_protocol", valid_579179
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

proc call*(call_579181: Call_ServicebrokerTestIamPermissions_579165;
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
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_ServicebrokerTestIamPermissions_579165;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerTestIamPermissions
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
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  var body_579185 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "$.xgafv", newJString(Xgafv))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "uploadType", newJString(uploadType))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(path_579183, "resource", newJString(resource))
  if body != nil:
    body_579185 = body
  add(query_579184, "callback", newJString(callback))
  add(query_579184, "fields", newJString(fields))
  add(query_579184, "access_token", newJString(accessToken))
  add(query_579184, "upload_protocol", newJString(uploadProtocol))
  result = call_579182.call(path_579183, query_579184, nil, nil, body_579185)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_579165(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_579166, base: "/",
    url: url_ServicebrokerTestIamPermissions_579167, schemes: {Scheme.Https})
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
