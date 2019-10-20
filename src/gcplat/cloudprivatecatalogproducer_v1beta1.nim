
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Private Catalog Producer
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enables cloud users to manage and share enterprise catalogs intheir organizations.
## 
## https://cloud.google.com/private-catalog/
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
  gcpServiceName = "cloudprivatecatalogproducer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogproducerCatalogsCreate_578885 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsCreate_578887(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsCreate_578886(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Catalog resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_578888 = query.getOrDefault("key")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "key", valid_578888
  var valid_578889 = query.getOrDefault("prettyPrint")
  valid_578889 = validateParameter(valid_578889, JBool, required = false,
                                 default = newJBool(true))
  if valid_578889 != nil:
    section.add "prettyPrint", valid_578889
  var valid_578890 = query.getOrDefault("oauth_token")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "oauth_token", valid_578890
  var valid_578891 = query.getOrDefault("$.xgafv")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("1"))
  if valid_578891 != nil:
    section.add "$.xgafv", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("uploadType")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "uploadType", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("callback")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "callback", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  var valid_578897 = query.getOrDefault("access_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "access_token", valid_578897
  var valid_578898 = query.getOrDefault("upload_protocol")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "upload_protocol", valid_578898
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

proc call*(call_578900: Call_CloudprivatecatalogproducerCatalogsCreate_578885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Catalog resource.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_CloudprivatecatalogproducerCatalogsCreate_578885;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsCreate
  ## Creates a new Catalog resource.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578902 = newJObject()
  var body_578903 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578903 = body
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  result = call_578901.call(nil, query_578902, nil, nil, body_578903)

var cloudprivatecatalogproducerCatalogsCreate* = Call_CloudprivatecatalogproducerCatalogsCreate_578885(
    name: "cloudprivatecatalogproducerCatalogsCreate", meth: HttpMethod.HttpPost,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsCreate_578886,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsCreate_578887,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsList_578610 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsList_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##           : The maximum number of catalogs to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The resource name of the parent resource.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListCatalogs
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("parent")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "parent", valid_578744
  var valid_578745 = query.getOrDefault("quotaUser")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "quotaUser", valid_578745
  var valid_578746 = query.getOrDefault("pageToken")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "pageToken", valid_578746
  var valid_578747 = query.getOrDefault("callback")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "callback", valid_578747
  var valid_578748 = query.getOrDefault("fields")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "fields", valid_578748
  var valid_578749 = query.getOrDefault("access_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "access_token", valid_578749
  var valid_578750 = query.getOrDefault("upload_protocol")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "upload_protocol", valid_578750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578773: Call_CloudprivatecatalogproducerCatalogsList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  let valid = call_578773.validator(path, query, header, formData, body)
  let scheme = call_578773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578773.url(scheme.get, call_578773.host, call_578773.base,
                         call_578773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578773, url, valid)

proc call*(call_578844: Call_CloudprivatecatalogproducerCatalogsList_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsList
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalogs to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The resource name of the parent resource.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListCatalogs
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578845 = newJObject()
  add(query_578845, "key", newJString(key))
  add(query_578845, "prettyPrint", newJBool(prettyPrint))
  add(query_578845, "oauth_token", newJString(oauthToken))
  add(query_578845, "$.xgafv", newJString(Xgafv))
  add(query_578845, "pageSize", newJInt(pageSize))
  add(query_578845, "alt", newJString(alt))
  add(query_578845, "uploadType", newJString(uploadType))
  add(query_578845, "parent", newJString(parent))
  add(query_578845, "quotaUser", newJString(quotaUser))
  add(query_578845, "pageToken", newJString(pageToken))
  add(query_578845, "callback", newJString(callback))
  add(query_578845, "fields", newJString(fields))
  add(query_578845, "access_token", newJString(accessToken))
  add(query_578845, "upload_protocol", newJString(uploadProtocol))
  result = call_578844.call(nil, query_578845, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsList* = Call_CloudprivatecatalogproducerCatalogsList_578610(
    name: "cloudprivatecatalogproducerCatalogsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsList_578611, base: "/",
    url: url_CloudprivatecatalogproducerCatalogsList_578612,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsList_578904 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerOperationsList_578906(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudprivatecatalogproducerOperationsList_578905(path: JsonNode;
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
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name of the operation's parent resource.
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
  var valid_578907 = query.getOrDefault("key")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "key", valid_578907
  var valid_578908 = query.getOrDefault("prettyPrint")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(true))
  if valid_578908 != nil:
    section.add "prettyPrint", valid_578908
  var valid_578909 = query.getOrDefault("oauth_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "oauth_token", valid_578909
  var valid_578910 = query.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
  var valid_578911 = query.getOrDefault("$.xgafv")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("1"))
  if valid_578911 != nil:
    section.add "$.xgafv", valid_578911
  var valid_578912 = query.getOrDefault("pageSize")
  valid_578912 = validateParameter(valid_578912, JInt, required = false, default = nil)
  if valid_578912 != nil:
    section.add "pageSize", valid_578912
  var valid_578913 = query.getOrDefault("alt")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = newJString("json"))
  if valid_578913 != nil:
    section.add "alt", valid_578913
  var valid_578914 = query.getOrDefault("uploadType")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "uploadType", valid_578914
  var valid_578915 = query.getOrDefault("quotaUser")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "quotaUser", valid_578915
  var valid_578916 = query.getOrDefault("filter")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "filter", valid_578916
  var valid_578917 = query.getOrDefault("pageToken")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "pageToken", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_CloudprivatecatalogproducerOperationsList_578904;
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
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_CloudprivatecatalogproducerOperationsList_578904;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsList
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name of the operation's parent resource.
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
  var query_578924 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "name", newJString(name))
  add(query_578924, "$.xgafv", newJString(Xgafv))
  add(query_578924, "pageSize", newJInt(pageSize))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "uploadType", newJString(uploadType))
  add(query_578924, "quotaUser", newJString(quotaUser))
  add(query_578924, "filter", newJString(filter))
  add(query_578924, "pageToken", newJString(pageToken))
  add(query_578924, "callback", newJString(callback))
  add(query_578924, "fields", newJString(fields))
  add(query_578924, "access_token", newJString(accessToken))
  add(query_578924, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(nil, query_578924, nil, nil, nil)

var cloudprivatecatalogproducerOperationsList* = Call_CloudprivatecatalogproducerOperationsList_578904(
    name: "cloudprivatecatalogproducerOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/operations",
    validator: validate_CloudprivatecatalogproducerOperationsList_578905,
    base: "/", url: url_CloudprivatecatalogproducerOperationsList_578906,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578925 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578927(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578926(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the requested Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578942 = path.getOrDefault("name")
  valid_578942 = validateParameter(valid_578942, JString, required = true,
                                 default = nil)
  if valid_578942 != nil:
    section.add "name", valid_578942
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
  var valid_578943 = query.getOrDefault("key")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "key", valid_578943
  var valid_578944 = query.getOrDefault("prettyPrint")
  valid_578944 = validateParameter(valid_578944, JBool, required = false,
                                 default = newJBool(true))
  if valid_578944 != nil:
    section.add "prettyPrint", valid_578944
  var valid_578945 = query.getOrDefault("oauth_token")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "oauth_token", valid_578945
  var valid_578946 = query.getOrDefault("$.xgafv")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("1"))
  if valid_578946 != nil:
    section.add "$.xgafv", valid_578946
  var valid_578947 = query.getOrDefault("alt")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("json"))
  if valid_578947 != nil:
    section.add "alt", valid_578947
  var valid_578948 = query.getOrDefault("uploadType")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "uploadType", valid_578948
  var valid_578949 = query.getOrDefault("quotaUser")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "quotaUser", valid_578949
  var valid_578950 = query.getOrDefault("callback")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "callback", valid_578950
  var valid_578951 = query.getOrDefault("fields")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "fields", valid_578951
  var valid_578952 = query.getOrDefault("access_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "access_token", valid_578952
  var valid_578953 = query.getOrDefault("upload_protocol")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "upload_protocol", valid_578953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578954: Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578925;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the requested Version resource.
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578925;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsGet
  ## Returns the requested Version resource.
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
  ##       : The resource name of the version.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578956 = newJObject()
  var query_578957 = newJObject()
  add(query_578957, "key", newJString(key))
  add(query_578957, "prettyPrint", newJBool(prettyPrint))
  add(query_578957, "oauth_token", newJString(oauthToken))
  add(query_578957, "$.xgafv", newJString(Xgafv))
  add(query_578957, "alt", newJString(alt))
  add(query_578957, "uploadType", newJString(uploadType))
  add(query_578957, "quotaUser", newJString(quotaUser))
  add(path_578956, "name", newJString(name))
  add(query_578957, "callback", newJString(callback))
  add(query_578957, "fields", newJString(fields))
  add(query_578957, "access_token", newJString(accessToken))
  add(query_578957, "upload_protocol", newJString(uploadProtocol))
  result = call_578955.call(path_578956, query_578957, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsGet* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578925(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsGet",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578926,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsGet_578927,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578978 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578980(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578979(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a specific Version resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578981 = path.getOrDefault("name")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "name", valid_578981
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
  ##             : Field mask that controls which fields of the version should be updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("$.xgafv")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("1"))
  if valid_578985 != nil:
    section.add "$.xgafv", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("uploadType")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "uploadType", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("updateMask")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "updateMask", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("access_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "access_token", valid_578992
  var valid_578993 = query.getOrDefault("upload_protocol")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "upload_protocol", valid_578993
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

proc call*(call_578995: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a specific Version resource.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578978;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsPatch
  ## Updates a specific Version resource.
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
  ##       : Required. The resource name of the version, in the format
  ## `catalogs/{catalog_id}/products/{product_id}/versions/a-z*[a-z0-9]'.
  ## 
  ## A unique identifier for the version under a product, which can't
  ## be changed after the version is created. The final segment of the name must
  ## between 1 and 63 characters in length.
  ##   updateMask: string
  ##             : Field mask that controls which fields of the version should be updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  var body_578999 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(query_578998, "$.xgafv", newJString(Xgafv))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "uploadType", newJString(uploadType))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(path_578997, "name", newJString(name))
  add(query_578998, "updateMask", newJString(updateMask))
  if body != nil:
    body_578999 = body
  add(query_578998, "callback", newJString(callback))
  add(query_578998, "fields", newJString(fields))
  add(query_578998, "access_token", newJString(accessToken))
  add(query_578998, "upload_protocol", newJString(uploadProtocol))
  result = call_578996.call(path_578997, query_578998, nil, nil, body_578999)

var cloudprivatecatalogproducerCatalogsProductsVersionsPatch* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578978(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsPatch",
    meth: HttpMethod.HttpPatch,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578979,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_578980,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578958 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578960(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578959(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Hard deletes a Version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the version.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578961 = path.getOrDefault("name")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "name", valid_578961
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
  ##   force: JBool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("$.xgafv")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("1"))
  if valid_578965 != nil:
    section.add "$.xgafv", valid_578965
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("uploadType")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "uploadType", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("force")
  valid_578969 = validateParameter(valid_578969, JBool, required = false, default = nil)
  if valid_578969 != nil:
    section.add "force", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hard deletes a Version.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578958;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; force: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsDelete
  ## Hard deletes a Version.
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
  ##       : The resource name of the version.
  ##   force: bool
  ##        : Forces deletion of the `Catalog` and its `Association` resources.
  ## If the `Catalog` is still associated with other resources and
  ## force is not set to true, then the operation fails.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(path_578976, "name", newJString(name))
  add(query_578977, "force", newJBool(force))
  add(query_578977, "callback", newJString(callback))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsDelete* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578958(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsDelete",
    meth: HttpMethod.HttpDelete,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578959,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsDelete_578960,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsCancel_579000 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerOperationsCancel_579002(protocol: Scheme;
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

proc validate_CloudprivatecatalogproducerOperationsCancel_579001(path: JsonNode;
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
  var valid_579003 = path.getOrDefault("name")
  valid_579003 = validateParameter(valid_579003, JString, required = true,
                                 default = nil)
  if valid_579003 != nil:
    section.add "name", valid_579003
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
  var valid_579004 = query.getOrDefault("key")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "key", valid_579004
  var valid_579005 = query.getOrDefault("prettyPrint")
  valid_579005 = validateParameter(valid_579005, JBool, required = false,
                                 default = newJBool(true))
  if valid_579005 != nil:
    section.add "prettyPrint", valid_579005
  var valid_579006 = query.getOrDefault("oauth_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "oauth_token", valid_579006
  var valid_579007 = query.getOrDefault("$.xgafv")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("1"))
  if valid_579007 != nil:
    section.add "$.xgafv", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("uploadType")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "uploadType", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("callback")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "callback", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  var valid_579014 = query.getOrDefault("upload_protocol")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "upload_protocol", valid_579014
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

proc call*(call_579016: Call_CloudprivatecatalogproducerOperationsCancel_579000;
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
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_CloudprivatecatalogproducerOperationsCancel_579000;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsCancel
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
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  var body_579020 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(query_579019, "$.xgafv", newJString(Xgafv))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "uploadType", newJString(uploadType))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(path_579018, "name", newJString(name))
  if body != nil:
    body_579020 = body
  add(query_579019, "callback", newJString(callback))
  add(query_579019, "fields", newJString(fields))
  add(query_579019, "access_token", newJString(accessToken))
  add(query_579019, "upload_protocol", newJString(uploadProtocol))
  result = call_579017.call(path_579018, query_579019, nil, nil, body_579020)

var cloudprivatecatalogproducerOperationsCancel* = Call_CloudprivatecatalogproducerOperationsCancel_579000(
    name: "cloudprivatecatalogproducerOperationsCancel",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_CloudprivatecatalogproducerOperationsCancel_579001,
    base: "/", url: url_CloudprivatecatalogproducerOperationsCancel_579002,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCopy_579021 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsCopy_579023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCopy_579022(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Copies a Product under another Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the current product that is copied from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579024 = path.getOrDefault("name")
  valid_579024 = validateParameter(valid_579024, JString, required = true,
                                 default = nil)
  if valid_579024 != nil:
    section.add "name", valid_579024
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
  var valid_579025 = query.getOrDefault("key")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "key", valid_579025
  var valid_579026 = query.getOrDefault("prettyPrint")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "prettyPrint", valid_579026
  var valid_579027 = query.getOrDefault("oauth_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "oauth_token", valid_579027
  var valid_579028 = query.getOrDefault("$.xgafv")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("1"))
  if valid_579028 != nil:
    section.add "$.xgafv", valid_579028
  var valid_579029 = query.getOrDefault("alt")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("json"))
  if valid_579029 != nil:
    section.add "alt", valid_579029
  var valid_579030 = query.getOrDefault("uploadType")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "uploadType", valid_579030
  var valid_579031 = query.getOrDefault("quotaUser")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "quotaUser", valid_579031
  var valid_579032 = query.getOrDefault("callback")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "callback", valid_579032
  var valid_579033 = query.getOrDefault("fields")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "fields", valid_579033
  var valid_579034 = query.getOrDefault("access_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "access_token", valid_579034
  var valid_579035 = query.getOrDefault("upload_protocol")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "upload_protocol", valid_579035
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

proc call*(call_579037: Call_CloudprivatecatalogproducerCatalogsProductsCopy_579021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Copies a Product under another Catalog.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_CloudprivatecatalogproducerCatalogsProductsCopy_579021;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCopy
  ## Copies a Product under another Catalog.
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
  ##       : The resource name of the current product that is copied from.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  var body_579041 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(query_579040, "$.xgafv", newJString(Xgafv))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "uploadType", newJString(uploadType))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(path_579039, "name", newJString(name))
  if body != nil:
    body_579041 = body
  add(query_579040, "callback", newJString(callback))
  add(query_579040, "fields", newJString(fields))
  add(query_579040, "access_token", newJString(accessToken))
  add(query_579040, "upload_protocol", newJString(uploadProtocol))
  result = call_579038.call(path_579039, query_579040, nil, nil, body_579041)

var cloudprivatecatalogproducerCatalogsProductsCopy* = Call_CloudprivatecatalogproducerCatalogsProductsCopy_579021(
    name: "cloudprivatecatalogproducerCatalogsProductsCopy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:copy",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCopy_579022,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCopy_579023,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsUndelete_579042 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsUndelete_579044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsUndelete_579043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the catalog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579045 = path.getOrDefault("name")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "name", valid_579045
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
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("$.xgafv")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("1"))
  if valid_579049 != nil:
    section.add "$.xgafv", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("uploadType")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "uploadType", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("callback")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "callback", valid_579053
  var valid_579054 = query.getOrDefault("fields")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "fields", valid_579054
  var valid_579055 = query.getOrDefault("access_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "access_token", valid_579055
  var valid_579056 = query.getOrDefault("upload_protocol")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "upload_protocol", valid_579056
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

proc call*(call_579058: Call_CloudprivatecatalogproducerCatalogsUndelete_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_CloudprivatecatalogproducerCatalogsUndelete_579042;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsUndelete
  ## Undeletes a deleted Catalog and all resources under it.
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
  ##       : The resource name of the catalog.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579060 = newJObject()
  var query_579061 = newJObject()
  var body_579062 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(query_579061, "$.xgafv", newJString(Xgafv))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "uploadType", newJString(uploadType))
  add(query_579061, "quotaUser", newJString(quotaUser))
  add(path_579060, "name", newJString(name))
  if body != nil:
    body_579062 = body
  add(query_579061, "callback", newJString(callback))
  add(query_579061, "fields", newJString(fields))
  add(query_579061, "access_token", newJString(accessToken))
  add(query_579061, "upload_protocol", newJString(uploadProtocol))
  result = call_579059.call(path_579060, query_579061, nil, nil, body_579062)

var cloudprivatecatalogproducerCatalogsUndelete* = Call_CloudprivatecatalogproducerCatalogsUndelete_579042(
    name: "cloudprivatecatalogproducerCatalogsUndelete",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:undelete",
    validator: validate_CloudprivatecatalogproducerCatalogsUndelete_579043,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsUndelete_579044,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_579084 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsAssociationsCreate_579086(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_579085(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Association instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The `Catalog` resource's name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579087 = path.getOrDefault("parent")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "parent", valid_579087
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
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("$.xgafv")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("1"))
  if valid_579091 != nil:
    section.add "$.xgafv", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("uploadType")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "uploadType", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("callback")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "callback", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
  var valid_579097 = query.getOrDefault("access_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "access_token", valid_579097
  var valid_579098 = query.getOrDefault("upload_protocol")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "upload_protocol", valid_579098
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

proc call*(call_579100: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_579084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Association instance under a given Catalog.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_579084;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsCreate
  ## Creates an Association instance under a given Catalog.
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
  ##         : The `Catalog` resource's name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  var body_579104 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "$.xgafv", newJString(Xgafv))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "uploadType", newJString(uploadType))
  add(query_579103, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579104 = body
  add(query_579103, "callback", newJString(callback))
  add(path_579102, "parent", newJString(parent))
  add(query_579103, "fields", newJString(fields))
  add(query_579103, "access_token", newJString(accessToken))
  add(query_579103, "upload_protocol", newJString(uploadProtocol))
  result = call_579101.call(path_579102, query_579103, nil, nil, body_579104)

var cloudprivatecatalogproducerCatalogsAssociationsCreate* = Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_579084(
    name: "cloudprivatecatalogproducerCatalogsAssociationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_579085,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsCreate_579086,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsList_579063 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsAssociationsList_579065(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsList_579064(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all Association resources under a catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579066 = path.getOrDefault("parent")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "parent", valid_579066
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
  ##           : The maximum number of catalog associations to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("pageSize")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "pageSize", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("pageToken")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "pageToken", valid_579075
  var valid_579076 = query.getOrDefault("callback")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "callback", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  var valid_579078 = query.getOrDefault("access_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "access_token", valid_579078
  var valid_579079 = query.getOrDefault("upload_protocol")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "upload_protocol", valid_579079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579080: Call_CloudprivatecatalogproducerCatalogsAssociationsList_579063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Association resources under a catalog.
  ## 
  let valid = call_579080.validator(path, query, header, formData, body)
  let scheme = call_579080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579080.url(scheme.get, call_579080.host, call_579080.base,
                         call_579080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579080, url, valid)

proc call*(call_579081: Call_CloudprivatecatalogproducerCatalogsAssociationsList_579063;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsAssociationsList
  ## Lists all Association resources under a catalog.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of catalog associations to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A pagination token returned from the previous call to
  ## `ListAssociations`.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The resource name of the `Catalog` whose `Associations` are
  ## being retrieved. In the format `catalogs/<catalog>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579082 = newJObject()
  var query_579083 = newJObject()
  add(query_579083, "key", newJString(key))
  add(query_579083, "prettyPrint", newJBool(prettyPrint))
  add(query_579083, "oauth_token", newJString(oauthToken))
  add(query_579083, "$.xgafv", newJString(Xgafv))
  add(query_579083, "pageSize", newJInt(pageSize))
  add(query_579083, "alt", newJString(alt))
  add(query_579083, "uploadType", newJString(uploadType))
  add(query_579083, "quotaUser", newJString(quotaUser))
  add(query_579083, "pageToken", newJString(pageToken))
  add(query_579083, "callback", newJString(callback))
  add(path_579082, "parent", newJString(parent))
  add(query_579083, "fields", newJString(fields))
  add(query_579083, "access_token", newJString(accessToken))
  add(query_579083, "upload_protocol", newJString(uploadProtocol))
  result = call_579081.call(path_579082, query_579083, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsAssociationsList* = Call_CloudprivatecatalogproducerCatalogsAssociationsList_579063(
    name: "cloudprivatecatalogproducerCatalogsAssociationsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsList_579064,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsList_579065,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCreate_579127 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsCreate_579129(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCreate_579128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Product instance under a given Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The catalog name of the new product's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579130 = path.getOrDefault("parent")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "parent", valid_579130
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
  var valid_579131 = query.getOrDefault("key")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "key", valid_579131
  var valid_579132 = query.getOrDefault("prettyPrint")
  valid_579132 = validateParameter(valid_579132, JBool, required = false,
                                 default = newJBool(true))
  if valid_579132 != nil:
    section.add "prettyPrint", valid_579132
  var valid_579133 = query.getOrDefault("oauth_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "oauth_token", valid_579133
  var valid_579134 = query.getOrDefault("$.xgafv")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("1"))
  if valid_579134 != nil:
    section.add "$.xgafv", valid_579134
  var valid_579135 = query.getOrDefault("alt")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = newJString("json"))
  if valid_579135 != nil:
    section.add "alt", valid_579135
  var valid_579136 = query.getOrDefault("uploadType")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "uploadType", valid_579136
  var valid_579137 = query.getOrDefault("quotaUser")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "quotaUser", valid_579137
  var valid_579138 = query.getOrDefault("callback")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "callback", valid_579138
  var valid_579139 = query.getOrDefault("fields")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "fields", valid_579139
  var valid_579140 = query.getOrDefault("access_token")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "access_token", valid_579140
  var valid_579141 = query.getOrDefault("upload_protocol")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "upload_protocol", valid_579141
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

proc call*(call_579143: Call_CloudprivatecatalogproducerCatalogsProductsCreate_579127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Product instance under a given Catalog.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_CloudprivatecatalogproducerCatalogsProductsCreate_579127;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsCreate
  ## Creates a Product instance under a given Catalog.
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
  ##         : The catalog name of the new product's parent.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  var body_579147 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "$.xgafv", newJString(Xgafv))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "uploadType", newJString(uploadType))
  add(query_579146, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579147 = body
  add(query_579146, "callback", newJString(callback))
  add(path_579145, "parent", newJString(parent))
  add(query_579146, "fields", newJString(fields))
  add(query_579146, "access_token", newJString(accessToken))
  add(query_579146, "upload_protocol", newJString(uploadProtocol))
  result = call_579144.call(path_579145, query_579146, nil, nil, body_579147)

var cloudprivatecatalogproducerCatalogsProductsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsCreate_579127(
    name: "cloudprivatecatalogproducerCatalogsProductsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCreate_579128,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCreate_579129,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsList_579105 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsList_579107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsList_579106(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579108 = path.getOrDefault("parent")
  valid_579108 = validateParameter(valid_579108, JString, required = true,
                                 default = nil)
  if valid_579108 != nil:
    section.add "parent", valid_579108
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
  ##           : The maximum number of products to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListProducts
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579109 = query.getOrDefault("key")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "key", valid_579109
  var valid_579110 = query.getOrDefault("prettyPrint")
  valid_579110 = validateParameter(valid_579110, JBool, required = false,
                                 default = newJBool(true))
  if valid_579110 != nil:
    section.add "prettyPrint", valid_579110
  var valid_579111 = query.getOrDefault("oauth_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "oauth_token", valid_579111
  var valid_579112 = query.getOrDefault("$.xgafv")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("1"))
  if valid_579112 != nil:
    section.add "$.xgafv", valid_579112
  var valid_579113 = query.getOrDefault("pageSize")
  valid_579113 = validateParameter(valid_579113, JInt, required = false, default = nil)
  if valid_579113 != nil:
    section.add "pageSize", valid_579113
  var valid_579114 = query.getOrDefault("alt")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("json"))
  if valid_579114 != nil:
    section.add "alt", valid_579114
  var valid_579115 = query.getOrDefault("uploadType")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "uploadType", valid_579115
  var valid_579116 = query.getOrDefault("quotaUser")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "quotaUser", valid_579116
  var valid_579117 = query.getOrDefault("filter")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "filter", valid_579117
  var valid_579118 = query.getOrDefault("pageToken")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "pageToken", valid_579118
  var valid_579119 = query.getOrDefault("callback")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "callback", valid_579119
  var valid_579120 = query.getOrDefault("fields")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "fields", valid_579120
  var valid_579121 = query.getOrDefault("access_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "access_token", valid_579121
  var valid_579122 = query.getOrDefault("upload_protocol")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "upload_protocol", valid_579122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579123: Call_CloudprivatecatalogproducerCatalogsProductsList_579105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  let valid = call_579123.validator(path, query, header, formData, body)
  let scheme = call_579123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579123.url(scheme.get, call_579123.host, call_579123.base,
                         call_579123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579123, url, valid)

proc call*(call_579124: Call_CloudprivatecatalogproducerCatalogsProductsList_579105;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsList
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of products to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : A filter expression used to restrict the returned results based
  ## upon properties of the product.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListProducts
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The resource name of the parent resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579125 = newJObject()
  var query_579126 = newJObject()
  add(query_579126, "key", newJString(key))
  add(query_579126, "prettyPrint", newJBool(prettyPrint))
  add(query_579126, "oauth_token", newJString(oauthToken))
  add(query_579126, "$.xgafv", newJString(Xgafv))
  add(query_579126, "pageSize", newJInt(pageSize))
  add(query_579126, "alt", newJString(alt))
  add(query_579126, "uploadType", newJString(uploadType))
  add(query_579126, "quotaUser", newJString(quotaUser))
  add(query_579126, "filter", newJString(filter))
  add(query_579126, "pageToken", newJString(pageToken))
  add(query_579126, "callback", newJString(callback))
  add(path_579125, "parent", newJString(parent))
  add(query_579126, "fields", newJString(fields))
  add(query_579126, "access_token", newJString(accessToken))
  add(query_579126, "upload_protocol", newJString(uploadProtocol))
  result = call_579124.call(path_579125, query_579126, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsList* = Call_CloudprivatecatalogproducerCatalogsProductsList_579105(
    name: "cloudprivatecatalogproducerCatalogsProductsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsList_579106,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsList_579107,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579169 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579171(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579170(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a Version instance under a given Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The product name of the new version's parent.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579172 = path.getOrDefault("parent")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = nil)
  if valid_579172 != nil:
    section.add "parent", valid_579172
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
  var valid_579173 = query.getOrDefault("key")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "key", valid_579173
  var valid_579174 = query.getOrDefault("prettyPrint")
  valid_579174 = validateParameter(valid_579174, JBool, required = false,
                                 default = newJBool(true))
  if valid_579174 != nil:
    section.add "prettyPrint", valid_579174
  var valid_579175 = query.getOrDefault("oauth_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "oauth_token", valid_579175
  var valid_579176 = query.getOrDefault("$.xgafv")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = newJString("1"))
  if valid_579176 != nil:
    section.add "$.xgafv", valid_579176
  var valid_579177 = query.getOrDefault("alt")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("json"))
  if valid_579177 != nil:
    section.add "alt", valid_579177
  var valid_579178 = query.getOrDefault("uploadType")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "uploadType", valid_579178
  var valid_579179 = query.getOrDefault("quotaUser")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "quotaUser", valid_579179
  var valid_579180 = query.getOrDefault("callback")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "callback", valid_579180
  var valid_579181 = query.getOrDefault("fields")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "fields", valid_579181
  var valid_579182 = query.getOrDefault("access_token")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "access_token", valid_579182
  var valid_579183 = query.getOrDefault("upload_protocol")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "upload_protocol", valid_579183
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

proc call*(call_579185: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Version instance under a given Product.
  ## 
  let valid = call_579185.validator(path, query, header, formData, body)
  let scheme = call_579185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579185.url(scheme.get, call_579185.host, call_579185.base,
                         call_579185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579185, url, valid)

proc call*(call_579186: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579169;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsCreate
  ## Creates a Version instance under a given Product.
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
  ##         : The product name of the new version's parent.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579187 = newJObject()
  var query_579188 = newJObject()
  var body_579189 = newJObject()
  add(query_579188, "key", newJString(key))
  add(query_579188, "prettyPrint", newJBool(prettyPrint))
  add(query_579188, "oauth_token", newJString(oauthToken))
  add(query_579188, "$.xgafv", newJString(Xgafv))
  add(query_579188, "alt", newJString(alt))
  add(query_579188, "uploadType", newJString(uploadType))
  add(query_579188, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579189 = body
  add(query_579188, "callback", newJString(callback))
  add(path_579187, "parent", newJString(parent))
  add(query_579188, "fields", newJString(fields))
  add(query_579188, "access_token", newJString(accessToken))
  add(query_579188, "upload_protocol", newJString(uploadProtocol))
  result = call_579186.call(path_579187, query_579188, nil, nil, body_579189)

var cloudprivatecatalogproducerCatalogsProductsVersionsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579169(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579170,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_579171,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_579148 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsList_579150(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_579149(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The resource name of the parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579151 = path.getOrDefault("parent")
  valid_579151 = validateParameter(valid_579151, JString, required = true,
                                 default = nil)
  if valid_579151 != nil:
    section.add "parent", valid_579151
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
  ##           : The maximum number of versions to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to ListVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579152 = query.getOrDefault("key")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "key", valid_579152
  var valid_579153 = query.getOrDefault("prettyPrint")
  valid_579153 = validateParameter(valid_579153, JBool, required = false,
                                 default = newJBool(true))
  if valid_579153 != nil:
    section.add "prettyPrint", valid_579153
  var valid_579154 = query.getOrDefault("oauth_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "oauth_token", valid_579154
  var valid_579155 = query.getOrDefault("$.xgafv")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = newJString("1"))
  if valid_579155 != nil:
    section.add "$.xgafv", valid_579155
  var valid_579156 = query.getOrDefault("pageSize")
  valid_579156 = validateParameter(valid_579156, JInt, required = false, default = nil)
  if valid_579156 != nil:
    section.add "pageSize", valid_579156
  var valid_579157 = query.getOrDefault("alt")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("json"))
  if valid_579157 != nil:
    section.add "alt", valid_579157
  var valid_579158 = query.getOrDefault("uploadType")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "uploadType", valid_579158
  var valid_579159 = query.getOrDefault("quotaUser")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "quotaUser", valid_579159
  var valid_579160 = query.getOrDefault("pageToken")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "pageToken", valid_579160
  var valid_579161 = query.getOrDefault("callback")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "callback", valid_579161
  var valid_579162 = query.getOrDefault("fields")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "fields", valid_579162
  var valid_579163 = query.getOrDefault("access_token")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "access_token", valid_579163
  var valid_579164 = query.getOrDefault("upload_protocol")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "upload_protocol", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579165: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_579148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  let valid = call_579165.validator(path, query, header, formData, body)
  let scheme = call_579165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579165.url(scheme.get, call_579165.host, call_579165.base,
                         call_579165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579165, url, valid)

proc call*(call_579166: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_579148;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsVersionsList
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of versions to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to ListVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The resource name of the parent resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579167 = newJObject()
  var query_579168 = newJObject()
  add(query_579168, "key", newJString(key))
  add(query_579168, "prettyPrint", newJBool(prettyPrint))
  add(query_579168, "oauth_token", newJString(oauthToken))
  add(query_579168, "$.xgafv", newJString(Xgafv))
  add(query_579168, "pageSize", newJInt(pageSize))
  add(query_579168, "alt", newJString(alt))
  add(query_579168, "uploadType", newJString(uploadType))
  add(query_579168, "quotaUser", newJString(quotaUser))
  add(query_579168, "pageToken", newJString(pageToken))
  add(query_579168, "callback", newJString(callback))
  add(path_579167, "parent", newJString(parent))
  add(query_579168, "fields", newJString(fields))
  add(query_579168, "access_token", newJString(accessToken))
  add(query_579168, "upload_protocol", newJString(uploadProtocol))
  result = call_579166.call(path_579167, query_579168, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsList* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_579148(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_579149,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsList_579150,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579190 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579192(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "product" in path, "`product` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "product"),
               (kind: ConstantSegment, value: "/icons:upload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579191(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   product: JString (required)
  ##          : The resource name of the product.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `product` field"
  var valid_579193 = path.getOrDefault("product")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "product", valid_579193
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
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("$.xgafv")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("1"))
  if valid_579197 != nil:
    section.add "$.xgafv", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("uploadType")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "uploadType", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  var valid_579201 = query.getOrDefault("callback")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "callback", valid_579201
  var valid_579202 = query.getOrDefault("fields")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "fields", valid_579202
  var valid_579203 = query.getOrDefault("access_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "access_token", valid_579203
  var valid_579204 = query.getOrDefault("upload_protocol")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "upload_protocol", valid_579204
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

proc call*(call_579206: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  let valid = call_579206.validator(path, query, header, formData, body)
  let scheme = call_579206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579206.url(scheme.get, call_579206.host, call_579206.base,
                         call_579206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579206, url, valid)

proc call*(call_579207: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579190;
          product: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsProductsIconsUpload
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
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
  ##   product: string (required)
  ##          : The resource name of the product.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579208 = newJObject()
  var query_579209 = newJObject()
  var body_579210 = newJObject()
  add(query_579209, "key", newJString(key))
  add(query_579209, "prettyPrint", newJBool(prettyPrint))
  add(query_579209, "oauth_token", newJString(oauthToken))
  add(query_579209, "$.xgafv", newJString(Xgafv))
  add(query_579209, "alt", newJString(alt))
  add(query_579209, "uploadType", newJString(uploadType))
  add(query_579209, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579210 = body
  add(query_579209, "callback", newJString(callback))
  add(path_579208, "product", newJString(product))
  add(query_579209, "fields", newJString(fields))
  add(query_579209, "access_token", newJString(accessToken))
  add(query_579209, "upload_protocol", newJString(uploadProtocol))
  result = call_579207.call(path_579208, query_579209, nil, nil, body_579210)

var cloudprivatecatalogproducerCatalogsProductsIconsUpload* = Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579190(
    name: "cloudprivatecatalogproducerCatalogsProductsIconsUpload",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{product}/icons:upload",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579191,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_579192,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_579211 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsGetIamPolicy_579213(protocol: Scheme;
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

proc validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_579212(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579214 = path.getOrDefault("resource")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "resource", valid_579214
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
  var valid_579215 = query.getOrDefault("key")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "key", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("$.xgafv")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("1"))
  if valid_579218 != nil:
    section.add "$.xgafv", valid_579218
  var valid_579219 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579219 = validateParameter(valid_579219, JInt, required = false, default = nil)
  if valid_579219 != nil:
    section.add "options.requestedPolicyVersion", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("uploadType")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "uploadType", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("callback")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "callback", valid_579223
  var valid_579224 = query.getOrDefault("fields")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "fields", valid_579224
  var valid_579225 = query.getOrDefault("access_token")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "access_token", valid_579225
  var valid_579226 = query.getOrDefault("upload_protocol")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "upload_protocol", valid_579226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579227: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_579211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets IAM policy for the specified Catalog.
  ## 
  let valid = call_579227.validator(path, query, header, formData, body)
  let scheme = call_579227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579227.url(scheme.get, call_579227.host, call_579227.base,
                         call_579227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579227, url, valid)

proc call*(call_579228: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_579211;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsGetIamPolicy
  ## Gets IAM policy for the specified Catalog.
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
  var path_579229 = newJObject()
  var query_579230 = newJObject()
  add(query_579230, "key", newJString(key))
  add(query_579230, "prettyPrint", newJBool(prettyPrint))
  add(query_579230, "oauth_token", newJString(oauthToken))
  add(query_579230, "$.xgafv", newJString(Xgafv))
  add(query_579230, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579230, "alt", newJString(alt))
  add(query_579230, "uploadType", newJString(uploadType))
  add(query_579230, "quotaUser", newJString(quotaUser))
  add(path_579229, "resource", newJString(resource))
  add(query_579230, "callback", newJString(callback))
  add(query_579230, "fields", newJString(fields))
  add(query_579230, "access_token", newJString(accessToken))
  add(query_579230, "upload_protocol", newJString(uploadProtocol))
  result = call_579228.call(path_579229, query_579230, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsGetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_579211(
    name: "cloudprivatecatalogproducerCatalogsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_579212,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsGetIamPolicy_579213,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_579231 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsSetIamPolicy_579233(protocol: Scheme;
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

proc validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_579232(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579234 = path.getOrDefault("resource")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = nil)
  if valid_579234 != nil:
    section.add "resource", valid_579234
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
  var valid_579235 = query.getOrDefault("key")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "key", valid_579235
  var valid_579236 = query.getOrDefault("prettyPrint")
  valid_579236 = validateParameter(valid_579236, JBool, required = false,
                                 default = newJBool(true))
  if valid_579236 != nil:
    section.add "prettyPrint", valid_579236
  var valid_579237 = query.getOrDefault("oauth_token")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "oauth_token", valid_579237
  var valid_579238 = query.getOrDefault("$.xgafv")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = newJString("1"))
  if valid_579238 != nil:
    section.add "$.xgafv", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("uploadType")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "uploadType", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("callback")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "callback", valid_579242
  var valid_579243 = query.getOrDefault("fields")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "fields", valid_579243
  var valid_579244 = query.getOrDefault("access_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "access_token", valid_579244
  var valid_579245 = query.getOrDefault("upload_protocol")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "upload_protocol", valid_579245
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

proc call*(call_579247: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_579231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  let valid = call_579247.validator(path, query, header, formData, body)
  let scheme = call_579247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579247.url(scheme.get, call_579247.host, call_579247.base,
                         call_579247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579247, url, valid)

proc call*(call_579248: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_579231;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsSetIamPolicy
  ## Sets the IAM policy for the specified Catalog.
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
  var path_579249 = newJObject()
  var query_579250 = newJObject()
  var body_579251 = newJObject()
  add(query_579250, "key", newJString(key))
  add(query_579250, "prettyPrint", newJBool(prettyPrint))
  add(query_579250, "oauth_token", newJString(oauthToken))
  add(query_579250, "$.xgafv", newJString(Xgafv))
  add(query_579250, "alt", newJString(alt))
  add(query_579250, "uploadType", newJString(uploadType))
  add(query_579250, "quotaUser", newJString(quotaUser))
  add(path_579249, "resource", newJString(resource))
  if body != nil:
    body_579251 = body
  add(query_579250, "callback", newJString(callback))
  add(query_579250, "fields", newJString(fields))
  add(query_579250, "access_token", newJString(accessToken))
  add(query_579250, "upload_protocol", newJString(uploadProtocol))
  result = call_579248.call(path_579249, query_579250, nil, nil, body_579251)

var cloudprivatecatalogproducerCatalogsSetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_579231(
    name: "cloudprivatecatalogproducerCatalogsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_579232,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsSetIamPolicy_579233,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_579252 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogproducerCatalogsTestIamPermissions_579254(
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

proc validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_579253(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579255 = path.getOrDefault("resource")
  valid_579255 = validateParameter(valid_579255, JString, required = true,
                                 default = nil)
  if valid_579255 != nil:
    section.add "resource", valid_579255
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
  var valid_579256 = query.getOrDefault("key")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "key", valid_579256
  var valid_579257 = query.getOrDefault("prettyPrint")
  valid_579257 = validateParameter(valid_579257, JBool, required = false,
                                 default = newJBool(true))
  if valid_579257 != nil:
    section.add "prettyPrint", valid_579257
  var valid_579258 = query.getOrDefault("oauth_token")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "oauth_token", valid_579258
  var valid_579259 = query.getOrDefault("$.xgafv")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = newJString("1"))
  if valid_579259 != nil:
    section.add "$.xgafv", valid_579259
  var valid_579260 = query.getOrDefault("alt")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("json"))
  if valid_579260 != nil:
    section.add "alt", valid_579260
  var valid_579261 = query.getOrDefault("uploadType")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "uploadType", valid_579261
  var valid_579262 = query.getOrDefault("quotaUser")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "quotaUser", valid_579262
  var valid_579263 = query.getOrDefault("callback")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "callback", valid_579263
  var valid_579264 = query.getOrDefault("fields")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "fields", valid_579264
  var valid_579265 = query.getOrDefault("access_token")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "access_token", valid_579265
  var valid_579266 = query.getOrDefault("upload_protocol")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "upload_protocol", valid_579266
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

proc call*(call_579268: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_579252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  let valid = call_579268.validator(path, query, header, formData, body)
  let scheme = call_579268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579268.url(scheme.get, call_579268.host, call_579268.base,
                         call_579268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579268, url, valid)

proc call*(call_579269: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_579252;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerCatalogsTestIamPermissions
  ## Tests the IAM permissions for the specified Catalog.
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
  var path_579270 = newJObject()
  var query_579271 = newJObject()
  var body_579272 = newJObject()
  add(query_579271, "key", newJString(key))
  add(query_579271, "prettyPrint", newJBool(prettyPrint))
  add(query_579271, "oauth_token", newJString(oauthToken))
  add(query_579271, "$.xgafv", newJString(Xgafv))
  add(query_579271, "alt", newJString(alt))
  add(query_579271, "uploadType", newJString(uploadType))
  add(query_579271, "quotaUser", newJString(quotaUser))
  add(path_579270, "resource", newJString(resource))
  if body != nil:
    body_579272 = body
  add(query_579271, "callback", newJString(callback))
  add(query_579271, "fields", newJString(fields))
  add(query_579271, "access_token", newJString(accessToken))
  add(query_579271, "upload_protocol", newJString(uploadProtocol))
  result = call_579269.call(path_579270, query_579271, nil, nil, body_579272)

var cloudprivatecatalogproducerCatalogsTestIamPermissions* = Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_579252(
    name: "cloudprivatecatalogproducerCatalogsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_579253,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsTestIamPermissions_579254,
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
