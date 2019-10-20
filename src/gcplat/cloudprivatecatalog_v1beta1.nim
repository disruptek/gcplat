
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Private Catalog
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Enable cloud users to discover enterprise catalogs and products in their organizations.
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
  gcpServiceName = "cloudprivatecatalog"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogProjectsCatalogsSearch_578610 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogProjectsCatalogsSearch_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/catalogs:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogProjectsCatalogsSearch_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578738 = path.getOrDefault("resource")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "resource", valid_578738
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
  ##           : The maximum number of entries that are requested.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   query: JString
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  var valid_578756 = query.getOrDefault("pageSize")
  valid_578756 = validateParameter(valid_578756, JInt, required = false, default = nil)
  if valid_578756 != nil:
    section.add "pageSize", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("pageToken")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "pageToken", valid_578760
  var valid_578761 = query.getOrDefault("query")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "query", valid_578761
  var valid_578762 = query.getOrDefault("callback")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "callback", valid_578762
  var valid_578763 = query.getOrDefault("fields")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "fields", valid_578763
  var valid_578764 = query.getOrDefault("access_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "access_token", valid_578764
  var valid_578765 = query.getOrDefault("upload_protocol")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "upload_protocol", valid_578765
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578788: Call_CloudprivatecatalogProjectsCatalogsSearch_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_578788.validator(path, query, header, formData, body)
  let scheme = call_578788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578788.url(scheme.get, call_578788.host, call_578788.base,
                         call_578788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578788, url, valid)

proc call*(call_578859: Call_CloudprivatecatalogProjectsCatalogsSearch_578610;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogProjectsCatalogsSearch
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   query: string
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578860 = newJObject()
  var query_578862 = newJObject()
  add(query_578862, "key", newJString(key))
  add(query_578862, "prettyPrint", newJBool(prettyPrint))
  add(query_578862, "oauth_token", newJString(oauthToken))
  add(query_578862, "$.xgafv", newJString(Xgafv))
  add(query_578862, "pageSize", newJInt(pageSize))
  add(query_578862, "alt", newJString(alt))
  add(query_578862, "uploadType", newJString(uploadType))
  add(query_578862, "quotaUser", newJString(quotaUser))
  add(path_578860, "resource", newJString(resource))
  add(query_578862, "pageToken", newJString(pageToken))
  add(query_578862, "query", newJString(query))
  add(query_578862, "callback", newJString(callback))
  add(query_578862, "fields", newJString(fields))
  add(query_578862, "access_token", newJString(accessToken))
  add(query_578862, "upload_protocol", newJString(uploadProtocol))
  result = call_578859.call(path_578860, query_578862, nil, nil, nil)

var cloudprivatecatalogProjectsCatalogsSearch* = Call_CloudprivatecatalogProjectsCatalogsSearch_578610(
    name: "cloudprivatecatalogProjectsCatalogsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/catalogs:search",
    validator: validate_CloudprivatecatalogProjectsCatalogsSearch_578611,
    base: "/", url: url_CloudprivatecatalogProjectsCatalogsSearch_578612,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogProjectsProductsSearch_578901 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogProjectsProductsSearch_578903(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/products:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogProjectsProductsSearch_578902(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578904 = path.getOrDefault("resource")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "resource", valid_578904
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
  ##           : The maximum number of entries that are requested.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   query: JString
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("pageSize")
  valid_578909 = validateParameter(valid_578909, JInt, required = false, default = nil)
  if valid_578909 != nil:
    section.add "pageSize", valid_578909
  var valid_578910 = query.getOrDefault("alt")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("json"))
  if valid_578910 != nil:
    section.add "alt", valid_578910
  var valid_578911 = query.getOrDefault("uploadType")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "uploadType", valid_578911
  var valid_578912 = query.getOrDefault("quotaUser")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "quotaUser", valid_578912
  var valid_578913 = query.getOrDefault("pageToken")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "pageToken", valid_578913
  var valid_578914 = query.getOrDefault("query")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "query", valid_578914
  var valid_578915 = query.getOrDefault("callback")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "callback", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  var valid_578917 = query.getOrDefault("access_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "access_token", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578919: Call_CloudprivatecatalogProjectsProductsSearch_578901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_CloudprivatecatalogProjectsProductsSearch_578901;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogProjectsProductsSearch
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   query: string
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578921 = newJObject()
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "$.xgafv", newJString(Xgafv))
  add(query_578922, "pageSize", newJInt(pageSize))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "uploadType", newJString(uploadType))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(path_578921, "resource", newJString(resource))
  add(query_578922, "pageToken", newJString(pageToken))
  add(query_578922, "query", newJString(query))
  add(query_578922, "callback", newJString(callback))
  add(query_578922, "fields", newJString(fields))
  add(query_578922, "access_token", newJString(accessToken))
  add(query_578922, "upload_protocol", newJString(uploadProtocol))
  result = call_578920.call(path_578921, query_578922, nil, nil, nil)

var cloudprivatecatalogProjectsProductsSearch* = Call_CloudprivatecatalogProjectsProductsSearch_578901(
    name: "cloudprivatecatalogProjectsProductsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/products:search",
    validator: validate_CloudprivatecatalogProjectsProductsSearch_578902,
    base: "/", url: url_CloudprivatecatalogProjectsProductsSearch_578903,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogProjectsVersionsSearch_578923 = ref object of OpenApiRestCall_578339
proc url_CloudprivatecatalogProjectsVersionsSearch_578925(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/versions:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudprivatecatalogProjectsVersionsSearch_578924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578926 = path.getOrDefault("resource")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "resource", valid_578926
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
  ##           : The maximum number of entries that are requested.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   query: JString
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("$.xgafv")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("1"))
  if valid_578930 != nil:
    section.add "$.xgafv", valid_578930
  var valid_578931 = query.getOrDefault("pageSize")
  valid_578931 = validateParameter(valid_578931, JInt, required = false, default = nil)
  if valid_578931 != nil:
    section.add "pageSize", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("uploadType")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "uploadType", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("pageToken")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "pageToken", valid_578935
  var valid_578936 = query.getOrDefault("query")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "query", valid_578936
  var valid_578937 = query.getOrDefault("callback")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "callback", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("access_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "access_token", valid_578939
  var valid_578940 = query.getOrDefault("upload_protocol")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "upload_protocol", valid_578940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578941: Call_CloudprivatecatalogProjectsVersionsSearch_578923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_578941.validator(path, query, header, formData, body)
  let scheme = call_578941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578941.url(scheme.get, call_578941.host, call_578941.base,
                         call_578941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578941, url, valid)

proc call*(call_578942: Call_CloudprivatecatalogProjectsVersionsSearch_578923;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogProjectsVersionsSearch
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   query: string
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578943 = newJObject()
  var query_578944 = newJObject()
  add(query_578944, "key", newJString(key))
  add(query_578944, "prettyPrint", newJBool(prettyPrint))
  add(query_578944, "oauth_token", newJString(oauthToken))
  add(query_578944, "$.xgafv", newJString(Xgafv))
  add(query_578944, "pageSize", newJInt(pageSize))
  add(query_578944, "alt", newJString(alt))
  add(query_578944, "uploadType", newJString(uploadType))
  add(query_578944, "quotaUser", newJString(quotaUser))
  add(path_578943, "resource", newJString(resource))
  add(query_578944, "pageToken", newJString(pageToken))
  add(query_578944, "query", newJString(query))
  add(query_578944, "callback", newJString(callback))
  add(query_578944, "fields", newJString(fields))
  add(query_578944, "access_token", newJString(accessToken))
  add(query_578944, "upload_protocol", newJString(uploadProtocol))
  result = call_578942.call(path_578943, query_578944, nil, nil, nil)

var cloudprivatecatalogProjectsVersionsSearch* = Call_CloudprivatecatalogProjectsVersionsSearch_578923(
    name: "cloudprivatecatalogProjectsVersionsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/versions:search",
    validator: validate_CloudprivatecatalogProjectsVersionsSearch_578924,
    base: "/", url: url_CloudprivatecatalogProjectsVersionsSearch_578925,
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
