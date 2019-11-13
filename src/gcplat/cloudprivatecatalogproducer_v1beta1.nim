
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  Call_CloudprivatecatalogproducerCatalogsCreate_579910 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsCreate_579912(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsCreate_579911(path: JsonNode;
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
  var valid_579913 = query.getOrDefault("key")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "key", valid_579913
  var valid_579914 = query.getOrDefault("prettyPrint")
  valid_579914 = validateParameter(valid_579914, JBool, required = false,
                                 default = newJBool(true))
  if valid_579914 != nil:
    section.add "prettyPrint", valid_579914
  var valid_579915 = query.getOrDefault("oauth_token")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "oauth_token", valid_579915
  var valid_579916 = query.getOrDefault("$.xgafv")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = newJString("1"))
  if valid_579916 != nil:
    section.add "$.xgafv", valid_579916
  var valid_579917 = query.getOrDefault("alt")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("json"))
  if valid_579917 != nil:
    section.add "alt", valid_579917
  var valid_579918 = query.getOrDefault("uploadType")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "uploadType", valid_579918
  var valid_579919 = query.getOrDefault("quotaUser")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "quotaUser", valid_579919
  var valid_579920 = query.getOrDefault("callback")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "callback", valid_579920
  var valid_579921 = query.getOrDefault("fields")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "fields", valid_579921
  var valid_579922 = query.getOrDefault("access_token")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "access_token", valid_579922
  var valid_579923 = query.getOrDefault("upload_protocol")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "upload_protocol", valid_579923
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

proc call*(call_579925: Call_CloudprivatecatalogproducerCatalogsCreate_579910;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Catalog resource.
  ## 
  let valid = call_579925.validator(path, query, header, formData, body)
  let scheme = call_579925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579925.url(scheme.get, call_579925.host, call_579925.base,
                         call_579925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579925, url, valid)

proc call*(call_579926: Call_CloudprivatecatalogproducerCatalogsCreate_579910;
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
  var query_579927 = newJObject()
  var body_579928 = newJObject()
  add(query_579927, "key", newJString(key))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579928 = body
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  result = call_579926.call(nil, query_579927, nil, nil, body_579928)

var cloudprivatecatalogproducerCatalogsCreate* = Call_CloudprivatecatalogproducerCatalogsCreate_579910(
    name: "cloudprivatecatalogproducerCatalogsCreate", meth: HttpMethod.HttpPost,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsCreate_579911,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsCreate_579912,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsList_579635 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsList_579637(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudprivatecatalogproducerCatalogsList_579636(path: JsonNode;
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
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("$.xgafv")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("1"))
  if valid_579765 != nil:
    section.add "$.xgafv", valid_579765
  var valid_579766 = query.getOrDefault("pageSize")
  valid_579766 = validateParameter(valid_579766, JInt, required = false, default = nil)
  if valid_579766 != nil:
    section.add "pageSize", valid_579766
  var valid_579767 = query.getOrDefault("alt")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = newJString("json"))
  if valid_579767 != nil:
    section.add "alt", valid_579767
  var valid_579768 = query.getOrDefault("uploadType")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "uploadType", valid_579768
  var valid_579769 = query.getOrDefault("parent")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "parent", valid_579769
  var valid_579770 = query.getOrDefault("quotaUser")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "quotaUser", valid_579770
  var valid_579771 = query.getOrDefault("pageToken")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "pageToken", valid_579771
  var valid_579772 = query.getOrDefault("callback")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "callback", valid_579772
  var valid_579773 = query.getOrDefault("fields")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "fields", valid_579773
  var valid_579774 = query.getOrDefault("access_token")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "access_token", valid_579774
  var valid_579775 = query.getOrDefault("upload_protocol")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "upload_protocol", valid_579775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579798: Call_CloudprivatecatalogproducerCatalogsList_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Catalog resources that the producer has access to, within the
  ## scope of the parent resource.
  ## 
  let valid = call_579798.validator(path, query, header, formData, body)
  let scheme = call_579798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579798.url(scheme.get, call_579798.host, call_579798.base,
                         call_579798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579798, url, valid)

proc call*(call_579869: Call_CloudprivatecatalogproducerCatalogsList_579635;
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
  var query_579870 = newJObject()
  add(query_579870, "key", newJString(key))
  add(query_579870, "prettyPrint", newJBool(prettyPrint))
  add(query_579870, "oauth_token", newJString(oauthToken))
  add(query_579870, "$.xgafv", newJString(Xgafv))
  add(query_579870, "pageSize", newJInt(pageSize))
  add(query_579870, "alt", newJString(alt))
  add(query_579870, "uploadType", newJString(uploadType))
  add(query_579870, "parent", newJString(parent))
  add(query_579870, "quotaUser", newJString(quotaUser))
  add(query_579870, "pageToken", newJString(pageToken))
  add(query_579870, "callback", newJString(callback))
  add(query_579870, "fields", newJString(fields))
  add(query_579870, "access_token", newJString(accessToken))
  add(query_579870, "upload_protocol", newJString(uploadProtocol))
  result = call_579869.call(nil, query_579870, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsList* = Call_CloudprivatecatalogproducerCatalogsList_579635(
    name: "cloudprivatecatalogproducerCatalogsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/catalogs",
    validator: validate_CloudprivatecatalogproducerCatalogsList_579636, base: "/",
    url: url_CloudprivatecatalogproducerCatalogsList_579637,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsList_579929 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerOperationsList_579931(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudprivatecatalogproducerOperationsList_579930(path: JsonNode;
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
  var valid_579932 = query.getOrDefault("key")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "key", valid_579932
  var valid_579933 = query.getOrDefault("prettyPrint")
  valid_579933 = validateParameter(valid_579933, JBool, required = false,
                                 default = newJBool(true))
  if valid_579933 != nil:
    section.add "prettyPrint", valid_579933
  var valid_579934 = query.getOrDefault("oauth_token")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "oauth_token", valid_579934
  var valid_579935 = query.getOrDefault("name")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "name", valid_579935
  var valid_579936 = query.getOrDefault("$.xgafv")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = newJString("1"))
  if valid_579936 != nil:
    section.add "$.xgafv", valid_579936
  var valid_579937 = query.getOrDefault("pageSize")
  valid_579937 = validateParameter(valid_579937, JInt, required = false, default = nil)
  if valid_579937 != nil:
    section.add "pageSize", valid_579937
  var valid_579938 = query.getOrDefault("alt")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = newJString("json"))
  if valid_579938 != nil:
    section.add "alt", valid_579938
  var valid_579939 = query.getOrDefault("uploadType")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "uploadType", valid_579939
  var valid_579940 = query.getOrDefault("quotaUser")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "quotaUser", valid_579940
  var valid_579941 = query.getOrDefault("filter")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "filter", valid_579941
  var valid_579942 = query.getOrDefault("pageToken")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "pageToken", valid_579942
  var valid_579943 = query.getOrDefault("callback")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "callback", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  var valid_579945 = query.getOrDefault("access_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "access_token", valid_579945
  var valid_579946 = query.getOrDefault("upload_protocol")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "upload_protocol", valid_579946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579947: Call_CloudprivatecatalogproducerOperationsList_579929;
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
  let valid = call_579947.validator(path, query, header, formData, body)
  let scheme = call_579947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579947.url(scheme.get, call_579947.host, call_579947.base,
                         call_579947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579947, url, valid)

proc call*(call_579948: Call_CloudprivatecatalogproducerOperationsList_579929;
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
  var query_579949 = newJObject()
  add(query_579949, "key", newJString(key))
  add(query_579949, "prettyPrint", newJBool(prettyPrint))
  add(query_579949, "oauth_token", newJString(oauthToken))
  add(query_579949, "name", newJString(name))
  add(query_579949, "$.xgafv", newJString(Xgafv))
  add(query_579949, "pageSize", newJInt(pageSize))
  add(query_579949, "alt", newJString(alt))
  add(query_579949, "uploadType", newJString(uploadType))
  add(query_579949, "quotaUser", newJString(quotaUser))
  add(query_579949, "filter", newJString(filter))
  add(query_579949, "pageToken", newJString(pageToken))
  add(query_579949, "callback", newJString(callback))
  add(query_579949, "fields", newJString(fields))
  add(query_579949, "access_token", newJString(accessToken))
  add(query_579949, "upload_protocol", newJString(uploadProtocol))
  result = call_579948.call(nil, query_579949, nil, nil, nil)

var cloudprivatecatalogproducerOperationsList* = Call_CloudprivatecatalogproducerOperationsList_579929(
    name: "cloudprivatecatalogproducerOperationsList", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/operations",
    validator: validate_CloudprivatecatalogproducerOperationsList_579930,
    base: "/", url: url_CloudprivatecatalogproducerOperationsList_579931,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsGet_579950 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerOperationsGet_579952(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsGet_579951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579967 = path.getOrDefault("name")
  valid_579967 = validateParameter(valid_579967, JString, required = true,
                                 default = nil)
  if valid_579967 != nil:
    section.add "name", valid_579967
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
  var valid_579968 = query.getOrDefault("key")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "key", valid_579968
  var valid_579969 = query.getOrDefault("prettyPrint")
  valid_579969 = validateParameter(valid_579969, JBool, required = false,
                                 default = newJBool(true))
  if valid_579969 != nil:
    section.add "prettyPrint", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("$.xgafv")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("1"))
  if valid_579971 != nil:
    section.add "$.xgafv", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("uploadType")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "uploadType", valid_579973
  var valid_579974 = query.getOrDefault("quotaUser")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "quotaUser", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("access_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "access_token", valid_579977
  var valid_579978 = query.getOrDefault("upload_protocol")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "upload_protocol", valid_579978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579979: Call_CloudprivatecatalogproducerOperationsGet_579950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_CloudprivatecatalogproducerOperationsGet_579950;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579981 = newJObject()
  var query_579982 = newJObject()
  add(query_579982, "key", newJString(key))
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "$.xgafv", newJString(Xgafv))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "uploadType", newJString(uploadType))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(path_579981, "name", newJString(name))
  add(query_579982, "callback", newJString(callback))
  add(query_579982, "fields", newJString(fields))
  add(query_579982, "access_token", newJString(accessToken))
  add(query_579982, "upload_protocol", newJString(uploadProtocol))
  result = call_579980.call(path_579981, query_579982, nil, nil, nil)

var cloudprivatecatalogproducerOperationsGet* = Call_CloudprivatecatalogproducerOperationsGet_579950(
    name: "cloudprivatecatalogproducerOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsGet_579951,
    base: "/", url: url_CloudprivatecatalogproducerOperationsGet_579952,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580003 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580005(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580004(
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
  var valid_580006 = path.getOrDefault("name")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "name", valid_580006
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
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("updateMask")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "updateMask", valid_580014
  var valid_580015 = query.getOrDefault("callback")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "callback", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("upload_protocol")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "upload_protocol", valid_580018
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

proc call*(call_580020: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a specific Version resource.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580003;
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
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  var body_580024 = newJObject()
  add(query_580023, "key", newJString(key))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(path_580022, "name", newJString(name))
  add(query_580023, "updateMask", newJString(updateMask))
  if body != nil:
    body_580024 = body
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  result = call_580021.call(path_580022, query_580023, nil, nil, body_580024)

var cloudprivatecatalogproducerCatalogsProductsVersionsPatch* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580003(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsPatch",
    meth: HttpMethod.HttpPatch,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580004,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsPatch_580005,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsDelete_579983 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerOperationsDelete_579985(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsDelete_579984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579986 = path.getOrDefault("name")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "name", valid_579986
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
  var valid_579987 = query.getOrDefault("key")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "key", valid_579987
  var valid_579988 = query.getOrDefault("prettyPrint")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "prettyPrint", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("$.xgafv")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("1"))
  if valid_579990 != nil:
    section.add "$.xgafv", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("uploadType")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "uploadType", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("force")
  valid_579994 = validateParameter(valid_579994, JBool, required = false, default = nil)
  if valid_579994 != nil:
    section.add "force", valid_579994
  var valid_579995 = query.getOrDefault("callback")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "callback", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("upload_protocol")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "upload_protocol", valid_579998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_CloudprivatecatalogproducerOperationsDelete_579983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_CloudprivatecatalogproducerOperationsDelete_579983;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; force: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogproducerOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
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
  ##       : The name of the operation resource to be deleted.
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
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "$.xgafv", newJString(Xgafv))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "uploadType", newJString(uploadType))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(path_580001, "name", newJString(name))
  add(query_580002, "force", newJBool(force))
  add(query_580002, "callback", newJString(callback))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "access_token", newJString(accessToken))
  add(query_580002, "upload_protocol", newJString(uploadProtocol))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var cloudprivatecatalogproducerOperationsDelete* = Call_CloudprivatecatalogproducerOperationsDelete_579983(
    name: "cloudprivatecatalogproducerOperationsDelete",
    meth: HttpMethod.HttpDelete,
    host: "cloudprivatecatalogproducer.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudprivatecatalogproducerOperationsDelete_579984,
    base: "/", url: url_CloudprivatecatalogproducerOperationsDelete_579985,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerOperationsCancel_580025 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerOperationsCancel_580027(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerOperationsCancel_580026(path: JsonNode;
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
  var valid_580028 = path.getOrDefault("name")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "name", valid_580028
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
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("upload_protocol")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "upload_protocol", valid_580039
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

proc call*(call_580041: Call_CloudprivatecatalogproducerOperationsCancel_580025;
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
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_CloudprivatecatalogproducerOperationsCancel_580025;
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
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  var body_580045 = newJObject()
  add(query_580044, "key", newJString(key))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "name", newJString(name))
  if body != nil:
    body_580045 = body
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  result = call_580042.call(path_580043, query_580044, nil, nil, body_580045)

var cloudprivatecatalogproducerOperationsCancel* = Call_CloudprivatecatalogproducerOperationsCancel_580025(
    name: "cloudprivatecatalogproducerOperationsCancel",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_CloudprivatecatalogproducerOperationsCancel_580026,
    base: "/", url: url_CloudprivatecatalogproducerOperationsCancel_580027,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCopy_580046 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsCopy_580048(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCopy_580047(
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
  var valid_580049 = path.getOrDefault("name")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "name", valid_580049
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
  var valid_580050 = query.getOrDefault("key")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "key", valid_580050
  var valid_580051 = query.getOrDefault("prettyPrint")
  valid_580051 = validateParameter(valid_580051, JBool, required = false,
                                 default = newJBool(true))
  if valid_580051 != nil:
    section.add "prettyPrint", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("uploadType")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "uploadType", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("callback")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "callback", valid_580057
  var valid_580058 = query.getOrDefault("fields")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "fields", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("upload_protocol")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "upload_protocol", valid_580060
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

proc call*(call_580062: Call_CloudprivatecatalogproducerCatalogsProductsCopy_580046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Copies a Product under another Catalog.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_CloudprivatecatalogproducerCatalogsProductsCopy_580046;
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
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "key", newJString(key))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "$.xgafv", newJString(Xgafv))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "uploadType", newJString(uploadType))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(path_580064, "name", newJString(name))
  if body != nil:
    body_580066 = body
  add(query_580065, "callback", newJString(callback))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "access_token", newJString(accessToken))
  add(query_580065, "upload_protocol", newJString(uploadProtocol))
  result = call_580063.call(path_580064, query_580065, nil, nil, body_580066)

var cloudprivatecatalogproducerCatalogsProductsCopy* = Call_CloudprivatecatalogproducerCatalogsProductsCopy_580046(
    name: "cloudprivatecatalogproducerCatalogsProductsCopy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:copy",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCopy_580047,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCopy_580048,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsUndelete_580067 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsUndelete_580069(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsUndelete_580068(path: JsonNode;
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
  var valid_580070 = path.getOrDefault("name")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "name", valid_580070
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
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("uploadType")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "uploadType", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("callback")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "callback", valid_580078
  var valid_580079 = query.getOrDefault("fields")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "fields", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("upload_protocol")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "upload_protocol", valid_580081
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

proc call*(call_580083: Call_CloudprivatecatalogproducerCatalogsUndelete_580067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Undeletes a deleted Catalog and all resources under it.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_CloudprivatecatalogproducerCatalogsUndelete_580067;
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
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  var body_580087 = newJObject()
  add(query_580086, "key", newJString(key))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "uploadType", newJString(uploadType))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(path_580085, "name", newJString(name))
  if body != nil:
    body_580087 = body
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  result = call_580084.call(path_580085, query_580086, nil, nil, body_580087)

var cloudprivatecatalogproducerCatalogsUndelete* = Call_CloudprivatecatalogproducerCatalogsUndelete_580067(
    name: "cloudprivatecatalogproducerCatalogsUndelete",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{name}:undelete",
    validator: validate_CloudprivatecatalogproducerCatalogsUndelete_580068,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsUndelete_580069,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580109 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsAssociationsCreate_580111(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_580110(
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
  var valid_580112 = path.getOrDefault("parent")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "parent", valid_580112
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
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("$.xgafv")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("1"))
  if valid_580116 != nil:
    section.add "$.xgafv", valid_580116
  var valid_580117 = query.getOrDefault("alt")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("json"))
  if valid_580117 != nil:
    section.add "alt", valid_580117
  var valid_580118 = query.getOrDefault("uploadType")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "uploadType", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("access_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "access_token", valid_580122
  var valid_580123 = query.getOrDefault("upload_protocol")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "upload_protocol", valid_580123
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

proc call*(call_580125: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Association instance under a given Catalog.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580109;
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
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  var body_580129 = newJObject()
  add(query_580128, "key", newJString(key))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "uploadType", newJString(uploadType))
  add(query_580128, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580129 = body
  add(query_580128, "callback", newJString(callback))
  add(path_580127, "parent", newJString(parent))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  result = call_580126.call(path_580127, query_580128, nil, nil, body_580129)

var cloudprivatecatalogproducerCatalogsAssociationsCreate* = Call_CloudprivatecatalogproducerCatalogsAssociationsCreate_580109(
    name: "cloudprivatecatalogproducerCatalogsAssociationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsCreate_580110,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsCreate_580111,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsAssociationsList_580088 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsAssociationsList_580090(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsAssociationsList_580089(
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
  var valid_580091 = path.getOrDefault("parent")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "parent", valid_580091
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
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("pageSize")
  valid_580096 = validateParameter(valid_580096, JInt, required = false, default = nil)
  if valid_580096 != nil:
    section.add "pageSize", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("pageToken")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "pageToken", valid_580100
  var valid_580101 = query.getOrDefault("callback")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "callback", valid_580101
  var valid_580102 = query.getOrDefault("fields")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "fields", valid_580102
  var valid_580103 = query.getOrDefault("access_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "access_token", valid_580103
  var valid_580104 = query.getOrDefault("upload_protocol")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "upload_protocol", valid_580104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_CloudprivatecatalogproducerCatalogsAssociationsList_580088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Association resources under a catalog.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_CloudprivatecatalogproducerCatalogsAssociationsList_580088;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(query_580108, "key", newJString(key))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "$.xgafv", newJString(Xgafv))
  add(query_580108, "pageSize", newJInt(pageSize))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "uploadType", newJString(uploadType))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "pageToken", newJString(pageToken))
  add(query_580108, "callback", newJString(callback))
  add(path_580107, "parent", newJString(parent))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "access_token", newJString(accessToken))
  add(query_580108, "upload_protocol", newJString(uploadProtocol))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsAssociationsList* = Call_CloudprivatecatalogproducerCatalogsAssociationsList_580088(
    name: "cloudprivatecatalogproducerCatalogsAssociationsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/associations",
    validator: validate_CloudprivatecatalogproducerCatalogsAssociationsList_580089,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsAssociationsList_580090,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsCreate_580152 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsCreate_580154(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsCreate_580153(
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
  var valid_580155 = path.getOrDefault("parent")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "parent", valid_580155
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
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("$.xgafv")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("1"))
  if valid_580159 != nil:
    section.add "$.xgafv", valid_580159
  var valid_580160 = query.getOrDefault("alt")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("json"))
  if valid_580160 != nil:
    section.add "alt", valid_580160
  var valid_580161 = query.getOrDefault("uploadType")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "uploadType", valid_580161
  var valid_580162 = query.getOrDefault("quotaUser")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "quotaUser", valid_580162
  var valid_580163 = query.getOrDefault("callback")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "callback", valid_580163
  var valid_580164 = query.getOrDefault("fields")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "fields", valid_580164
  var valid_580165 = query.getOrDefault("access_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "access_token", valid_580165
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
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

proc call*(call_580168: Call_CloudprivatecatalogproducerCatalogsProductsCreate_580152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Product instance under a given Catalog.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_CloudprivatecatalogproducerCatalogsProductsCreate_580152;
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
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  var body_580172 = newJObject()
  add(query_580171, "key", newJString(key))
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "$.xgafv", newJString(Xgafv))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "uploadType", newJString(uploadType))
  add(query_580171, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580172 = body
  add(query_580171, "callback", newJString(callback))
  add(path_580170, "parent", newJString(parent))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "access_token", newJString(accessToken))
  add(query_580171, "upload_protocol", newJString(uploadProtocol))
  result = call_580169.call(path_580170, query_580171, nil, nil, body_580172)

var cloudprivatecatalogproducerCatalogsProductsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsCreate_580152(
    name: "cloudprivatecatalogproducerCatalogsProductsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsCreate_580153,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsCreate_580154,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsList_580130 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsList_580132(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsList_580131(
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
  var valid_580133 = path.getOrDefault("parent")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "parent", valid_580133
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
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("$.xgafv")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("1"))
  if valid_580137 != nil:
    section.add "$.xgafv", valid_580137
  var valid_580138 = query.getOrDefault("pageSize")
  valid_580138 = validateParameter(valid_580138, JInt, required = false, default = nil)
  if valid_580138 != nil:
    section.add "pageSize", valid_580138
  var valid_580139 = query.getOrDefault("alt")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("json"))
  if valid_580139 != nil:
    section.add "alt", valid_580139
  var valid_580140 = query.getOrDefault("uploadType")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "uploadType", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("filter")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "filter", valid_580142
  var valid_580143 = query.getOrDefault("pageToken")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "pageToken", valid_580143
  var valid_580144 = query.getOrDefault("callback")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "callback", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("upload_protocol")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "upload_protocol", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_CloudprivatecatalogproducerCatalogsProductsList_580130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Product resources that the producer has access to, within the
  ## scope of the parent catalog.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_CloudprivatecatalogproducerCatalogsProductsList_580130;
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
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "$.xgafv", newJString(Xgafv))
  add(query_580151, "pageSize", newJInt(pageSize))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "uploadType", newJString(uploadType))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "filter", newJString(filter))
  add(query_580151, "pageToken", newJString(pageToken))
  add(query_580151, "callback", newJString(callback))
  add(path_580150, "parent", newJString(parent))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "access_token", newJString(accessToken))
  add(query_580151, "upload_protocol", newJString(uploadProtocol))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsList* = Call_CloudprivatecatalogproducerCatalogsProductsList_580130(
    name: "cloudprivatecatalogproducerCatalogsProductsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/products",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsList_580131,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsList_580132,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580194 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580196(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580195(
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
  var valid_580197 = path.getOrDefault("parent")
  valid_580197 = validateParameter(valid_580197, JString, required = true,
                                 default = nil)
  if valid_580197 != nil:
    section.add "parent", valid_580197
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
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("prettyPrint")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(true))
  if valid_580199 != nil:
    section.add "prettyPrint", valid_580199
  var valid_580200 = query.getOrDefault("oauth_token")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "oauth_token", valid_580200
  var valid_580201 = query.getOrDefault("$.xgafv")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = newJString("1"))
  if valid_580201 != nil:
    section.add "$.xgafv", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("uploadType")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "uploadType", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("callback")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "callback", valid_580205
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("access_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "access_token", valid_580207
  var valid_580208 = query.getOrDefault("upload_protocol")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "upload_protocol", valid_580208
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

proc call*(call_580210: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Version instance under a given Product.
  ## 
  let valid = call_580210.validator(path, query, header, formData, body)
  let scheme = call_580210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580210.url(scheme.get, call_580210.host, call_580210.base,
                         call_580210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580210, url, valid)

proc call*(call_580211: Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580194;
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
  var path_580212 = newJObject()
  var query_580213 = newJObject()
  var body_580214 = newJObject()
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "$.xgafv", newJString(Xgafv))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "uploadType", newJString(uploadType))
  add(query_580213, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580214 = body
  add(query_580213, "callback", newJString(callback))
  add(path_580212, "parent", newJString(parent))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "access_token", newJString(accessToken))
  add(query_580213, "upload_protocol", newJString(uploadProtocol))
  result = call_580211.call(path_580212, query_580213, nil, nil, body_580214)

var cloudprivatecatalogproducerCatalogsProductsVersionsCreate* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580194(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsCreate",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580195,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsCreate_580196,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580173 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsVersionsList_580175(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_580174(
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
  var valid_580176 = path.getOrDefault("parent")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "parent", valid_580176
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
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
  var valid_580179 = query.getOrDefault("oauth_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "oauth_token", valid_580179
  var valid_580180 = query.getOrDefault("$.xgafv")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("1"))
  if valid_580180 != nil:
    section.add "$.xgafv", valid_580180
  var valid_580181 = query.getOrDefault("pageSize")
  valid_580181 = validateParameter(valid_580181, JInt, required = false, default = nil)
  if valid_580181 != nil:
    section.add "pageSize", valid_580181
  var valid_580182 = query.getOrDefault("alt")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("json"))
  if valid_580182 != nil:
    section.add "alt", valid_580182
  var valid_580183 = query.getOrDefault("uploadType")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "uploadType", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("pageToken")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "pageToken", valid_580185
  var valid_580186 = query.getOrDefault("callback")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "callback", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  var valid_580188 = query.getOrDefault("access_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "access_token", valid_580188
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580190: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Version resources that the producer has access to, within the
  ## scope of the parent Product.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580173;
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
  var path_580192 = newJObject()
  var query_580193 = newJObject()
  add(query_580193, "key", newJString(key))
  add(query_580193, "prettyPrint", newJBool(prettyPrint))
  add(query_580193, "oauth_token", newJString(oauthToken))
  add(query_580193, "$.xgafv", newJString(Xgafv))
  add(query_580193, "pageSize", newJInt(pageSize))
  add(query_580193, "alt", newJString(alt))
  add(query_580193, "uploadType", newJString(uploadType))
  add(query_580193, "quotaUser", newJString(quotaUser))
  add(query_580193, "pageToken", newJString(pageToken))
  add(query_580193, "callback", newJString(callback))
  add(path_580192, "parent", newJString(parent))
  add(query_580193, "fields", newJString(fields))
  add(query_580193, "access_token", newJString(accessToken))
  add(query_580193, "upload_protocol", newJString(uploadProtocol))
  result = call_580191.call(path_580192, query_580193, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsProductsVersionsList* = Call_CloudprivatecatalogproducerCatalogsProductsVersionsList_580173(
    name: "cloudprivatecatalogproducerCatalogsProductsVersionsList",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{parent}/versions", validator: validate_CloudprivatecatalogproducerCatalogsProductsVersionsList_580174,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsVersionsList_580175,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580215 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580217(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580216(
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
  var valid_580218 = path.getOrDefault("product")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "product", valid_580218
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
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("$.xgafv")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("1"))
  if valid_580222 != nil:
    section.add "$.xgafv", valid_580222
  var valid_580223 = query.getOrDefault("alt")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("json"))
  if valid_580223 != nil:
    section.add "alt", valid_580223
  var valid_580224 = query.getOrDefault("uploadType")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "uploadType", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("callback")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "callback", valid_580226
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  var valid_580228 = query.getOrDefault("access_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "access_token", valid_580228
  var valid_580229 = query.getOrDefault("upload_protocol")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "upload_protocol", valid_580229
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

proc call*(call_580231: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an Icon instance under a given Product.
  ## If Product only has a default icon, a new Icon
  ## instance is created and associated with the given Product.
  ## If Product already has a non-default icon, the action creates
  ## a new Icon instance, associates the newly created
  ## Icon with the given Product and deletes the old icon.
  ## 
  let valid = call_580231.validator(path, query, header, formData, body)
  let scheme = call_580231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580231.url(scheme.get, call_580231.host, call_580231.base,
                         call_580231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580231, url, valid)

proc call*(call_580232: Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580215;
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
  var path_580233 = newJObject()
  var query_580234 = newJObject()
  var body_580235 = newJObject()
  add(query_580234, "key", newJString(key))
  add(query_580234, "prettyPrint", newJBool(prettyPrint))
  add(query_580234, "oauth_token", newJString(oauthToken))
  add(query_580234, "$.xgafv", newJString(Xgafv))
  add(query_580234, "alt", newJString(alt))
  add(query_580234, "uploadType", newJString(uploadType))
  add(query_580234, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580235 = body
  add(query_580234, "callback", newJString(callback))
  add(path_580233, "product", newJString(product))
  add(query_580234, "fields", newJString(fields))
  add(query_580234, "access_token", newJString(accessToken))
  add(query_580234, "upload_protocol", newJString(uploadProtocol))
  result = call_580232.call(path_580233, query_580234, nil, nil, body_580235)

var cloudprivatecatalogproducerCatalogsProductsIconsUpload* = Call_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580215(
    name: "cloudprivatecatalogproducerCatalogsProductsIconsUpload",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{product}/icons:upload",
    validator: validate_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580216,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsProductsIconsUpload_580217,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580236 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsGetIamPolicy_580238(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_580237(
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
  var valid_580239 = path.getOrDefault("resource")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "resource", valid_580239
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
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
  var valid_580242 = query.getOrDefault("oauth_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "oauth_token", valid_580242
  var valid_580243 = query.getOrDefault("$.xgafv")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("1"))
  if valid_580243 != nil:
    section.add "$.xgafv", valid_580243
  var valid_580244 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580244 = validateParameter(valid_580244, JInt, required = false, default = nil)
  if valid_580244 != nil:
    section.add "options.requestedPolicyVersion", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("uploadType")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "uploadType", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("callback")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "callback", valid_580248
  var valid_580249 = query.getOrDefault("fields")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fields", valid_580249
  var valid_580250 = query.getOrDefault("access_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "access_token", valid_580250
  var valid_580251 = query.getOrDefault("upload_protocol")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "upload_protocol", valid_580251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580252: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets IAM policy for the specified Catalog.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580236;
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
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  add(query_580255, "key", newJString(key))
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(query_580255, "$.xgafv", newJString(Xgafv))
  add(query_580255, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "uploadType", newJString(uploadType))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(path_580254, "resource", newJString(resource))
  add(query_580255, "callback", newJString(callback))
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "access_token", newJString(accessToken))
  add(query_580255, "upload_protocol", newJString(uploadProtocol))
  result = call_580253.call(path_580254, query_580255, nil, nil, nil)

var cloudprivatecatalogproducerCatalogsGetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsGetIamPolicy_580236(
    name: "cloudprivatecatalogproducerCatalogsGetIamPolicy",
    meth: HttpMethod.HttpGet, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsGetIamPolicy_580237,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsGetIamPolicy_580238,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580256 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsSetIamPolicy_580258(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_580257(
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
  var valid_580259 = path.getOrDefault("resource")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "resource", valid_580259
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
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("prettyPrint")
  valid_580261 = validateParameter(valid_580261, JBool, required = false,
                                 default = newJBool(true))
  if valid_580261 != nil:
    section.add "prettyPrint", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("$.xgafv")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("1"))
  if valid_580263 != nil:
    section.add "$.xgafv", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("uploadType")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "uploadType", valid_580265
  var valid_580266 = query.getOrDefault("quotaUser")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "quotaUser", valid_580266
  var valid_580267 = query.getOrDefault("callback")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "callback", valid_580267
  var valid_580268 = query.getOrDefault("fields")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "fields", valid_580268
  var valid_580269 = query.getOrDefault("access_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "access_token", valid_580269
  var valid_580270 = query.getOrDefault("upload_protocol")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "upload_protocol", valid_580270
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

proc call*(call_580272: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM policy for the specified Catalog.
  ## 
  let valid = call_580272.validator(path, query, header, formData, body)
  let scheme = call_580272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580272.url(scheme.get, call_580272.host, call_580272.base,
                         call_580272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580272, url, valid)

proc call*(call_580273: Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580256;
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
  var path_580274 = newJObject()
  var query_580275 = newJObject()
  var body_580276 = newJObject()
  add(query_580275, "key", newJString(key))
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "$.xgafv", newJString(Xgafv))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "uploadType", newJString(uploadType))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(path_580274, "resource", newJString(resource))
  if body != nil:
    body_580276 = body
  add(query_580275, "callback", newJString(callback))
  add(query_580275, "fields", newJString(fields))
  add(query_580275, "access_token", newJString(accessToken))
  add(query_580275, "upload_protocol", newJString(uploadProtocol))
  result = call_580273.call(path_580274, query_580275, nil, nil, body_580276)

var cloudprivatecatalogproducerCatalogsSetIamPolicy* = Call_CloudprivatecatalogproducerCatalogsSetIamPolicy_580256(
    name: "cloudprivatecatalogproducerCatalogsSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_CloudprivatecatalogproducerCatalogsSetIamPolicy_580257,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsSetIamPolicy_580258,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580277 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogproducerCatalogsTestIamPermissions_580279(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_580278(
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
  var valid_580280 = path.getOrDefault("resource")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "resource", valid_580280
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
  var valid_580281 = query.getOrDefault("key")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "key", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
  var valid_580283 = query.getOrDefault("oauth_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "oauth_token", valid_580283
  var valid_580284 = query.getOrDefault("$.xgafv")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("1"))
  if valid_580284 != nil:
    section.add "$.xgafv", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("uploadType")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "uploadType", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("callback")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "callback", valid_580288
  var valid_580289 = query.getOrDefault("fields")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "fields", valid_580289
  var valid_580290 = query.getOrDefault("access_token")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "access_token", valid_580290
  var valid_580291 = query.getOrDefault("upload_protocol")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "upload_protocol", valid_580291
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

proc call*(call_580293: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the IAM permissions for the specified Catalog.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580277;
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
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  var body_580297 = newJObject()
  add(query_580296, "key", newJString(key))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "$.xgafv", newJString(Xgafv))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "uploadType", newJString(uploadType))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(path_580295, "resource", newJString(resource))
  if body != nil:
    body_580297 = body
  add(query_580296, "callback", newJString(callback))
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "access_token", newJString(accessToken))
  add(query_580296, "upload_protocol", newJString(uploadProtocol))
  result = call_580294.call(path_580295, query_580296, nil, nil, body_580297)

var cloudprivatecatalogproducerCatalogsTestIamPermissions* = Call_CloudprivatecatalogproducerCatalogsTestIamPermissions_580277(
    name: "cloudprivatecatalogproducerCatalogsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "cloudprivatecatalogproducer.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_CloudprivatecatalogproducerCatalogsTestIamPermissions_580278,
    base: "/", url: url_CloudprivatecatalogproducerCatalogsTestIamPermissions_580279,
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
