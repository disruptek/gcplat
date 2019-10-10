
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
  gcpServiceName = "cloudprivatecatalog"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogProjectsCatalogsSearch_588710 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogProjectsCatalogsSearch_588712(protocol: Scheme;
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

proc validate_CloudprivatecatalogProjectsCatalogsSearch_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("resource")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "resource", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  ##           : The maximum number of entries that are requested.
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
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588856 = query.getOrDefault("alt")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("json"))
  if valid_588856 != nil:
    section.add "alt", valid_588856
  var valid_588857 = query.getOrDefault("query")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "query", valid_588857
  var valid_588858 = query.getOrDefault("oauth_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "oauth_token", valid_588858
  var valid_588859 = query.getOrDefault("callback")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "callback", valid_588859
  var valid_588860 = query.getOrDefault("access_token")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "access_token", valid_588860
  var valid_588861 = query.getOrDefault("uploadType")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "uploadType", valid_588861
  var valid_588862 = query.getOrDefault("key")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "key", valid_588862
  var valid_588863 = query.getOrDefault("$.xgafv")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("1"))
  if valid_588863 != nil:
    section.add "$.xgafv", valid_588863
  var valid_588864 = query.getOrDefault("pageSize")
  valid_588864 = validateParameter(valid_588864, JInt, required = false, default = nil)
  if valid_588864 != nil:
    section.add "pageSize", valid_588864
  var valid_588865 = query.getOrDefault("prettyPrint")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "prettyPrint", valid_588865
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588888: Call_CloudprivatecatalogProjectsCatalogsSearch_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_588888.validator(path, query, header, formData, body)
  let scheme = call_588888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588888.url(scheme.get, call_588888.host, call_588888.base,
                         call_588888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588888, url, valid)

proc call*(call_588959: Call_CloudprivatecatalogProjectsCatalogsSearch_588710;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogProjectsCatalogsSearch
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchCatalogs that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the catalogs. The supported queries are:
  ## 
  ## * Get a single catalog: `name=catalogs/{catalog_id}`
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
  ##           : Required. The name of the resource context. It can be in following formats:
  ## 
  ## * `projects/{project_id}`
  ## * `folders/{folder_id}`
  ## * `organizations/{organization_id}`
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588960 = newJObject()
  var query_588962 = newJObject()
  add(query_588962, "upload_protocol", newJString(uploadProtocol))
  add(query_588962, "fields", newJString(fields))
  add(query_588962, "pageToken", newJString(pageToken))
  add(query_588962, "quotaUser", newJString(quotaUser))
  add(query_588962, "alt", newJString(alt))
  add(query_588962, "query", newJString(query))
  add(query_588962, "oauth_token", newJString(oauthToken))
  add(query_588962, "callback", newJString(callback))
  add(query_588962, "access_token", newJString(accessToken))
  add(query_588962, "uploadType", newJString(uploadType))
  add(query_588962, "key", newJString(key))
  add(query_588962, "$.xgafv", newJString(Xgafv))
  add(path_588960, "resource", newJString(resource))
  add(query_588962, "pageSize", newJInt(pageSize))
  add(query_588962, "prettyPrint", newJBool(prettyPrint))
  result = call_588959.call(path_588960, query_588962, nil, nil, nil)

var cloudprivatecatalogProjectsCatalogsSearch* = Call_CloudprivatecatalogProjectsCatalogsSearch_588710(
    name: "cloudprivatecatalogProjectsCatalogsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/catalogs:search",
    validator: validate_CloudprivatecatalogProjectsCatalogsSearch_588711,
    base: "/", url: url_CloudprivatecatalogProjectsCatalogsSearch_588712,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogProjectsProductsSearch_589001 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogProjectsProductsSearch_589003(protocol: Scheme;
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

proc validate_CloudprivatecatalogProjectsProductsSearch_589002(path: JsonNode;
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
  var valid_589004 = path.getOrDefault("resource")
  valid_589004 = validateParameter(valid_589004, JString, required = true,
                                 default = nil)
  if valid_589004 != nil:
    section.add "resource", valid_589004
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
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
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589005 = query.getOrDefault("upload_protocol")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "upload_protocol", valid_589005
  var valid_589006 = query.getOrDefault("fields")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "fields", valid_589006
  var valid_589007 = query.getOrDefault("pageToken")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "pageToken", valid_589007
  var valid_589008 = query.getOrDefault("quotaUser")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "quotaUser", valid_589008
  var valid_589009 = query.getOrDefault("alt")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("json"))
  if valid_589009 != nil:
    section.add "alt", valid_589009
  var valid_589010 = query.getOrDefault("query")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "query", valid_589010
  var valid_589011 = query.getOrDefault("oauth_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "oauth_token", valid_589011
  var valid_589012 = query.getOrDefault("callback")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "callback", valid_589012
  var valid_589013 = query.getOrDefault("access_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "access_token", valid_589013
  var valid_589014 = query.getOrDefault("uploadType")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "uploadType", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("$.xgafv")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("1"))
  if valid_589016 != nil:
    section.add "$.xgafv", valid_589016
  var valid_589017 = query.getOrDefault("pageSize")
  valid_589017 = validateParameter(valid_589017, JInt, required = false, default = nil)
  if valid_589017 != nil:
    section.add "pageSize", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589019: Call_CloudprivatecatalogProjectsProductsSearch_589001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_CloudprivatecatalogProjectsProductsSearch_589001;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogProjectsProductsSearch
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchProducts that
  ## indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the products.
  ## 
  ## The supported queries are:
  ## * List products of all catalogs: empty
  ## * List products under a catalog: `parent=catalogs/{catalog_id}`
  ## * Get a product by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}`
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
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589021 = newJObject()
  var query_589022 = newJObject()
  add(query_589022, "upload_protocol", newJString(uploadProtocol))
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "pageToken", newJString(pageToken))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "query", newJString(query))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "callback", newJString(callback))
  add(query_589022, "access_token", newJString(accessToken))
  add(query_589022, "uploadType", newJString(uploadType))
  add(query_589022, "key", newJString(key))
  add(query_589022, "$.xgafv", newJString(Xgafv))
  add(path_589021, "resource", newJString(resource))
  add(query_589022, "pageSize", newJInt(pageSize))
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(path_589021, query_589022, nil, nil, nil)

var cloudprivatecatalogProjectsProductsSearch* = Call_CloudprivatecatalogProjectsProductsSearch_589001(
    name: "cloudprivatecatalogProjectsProductsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/products:search",
    validator: validate_CloudprivatecatalogProjectsProductsSearch_589002,
    base: "/", url: url_CloudprivatecatalogProjectsProductsSearch_589003,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogProjectsVersionsSearch_589023 = ref object of OpenApiRestCall_588441
proc url_CloudprivatecatalogProjectsVersionsSearch_589025(protocol: Scheme;
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

proc validate_CloudprivatecatalogProjectsVersionsSearch_589024(path: JsonNode;
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
  var valid_589026 = path.getOrDefault("resource")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "resource", valid_589026
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
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
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589027 = query.getOrDefault("upload_protocol")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "upload_protocol", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("pageToken")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "pageToken", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("query")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "query", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("callback")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "callback", valid_589034
  var valid_589035 = query.getOrDefault("access_token")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "access_token", valid_589035
  var valid_589036 = query.getOrDefault("uploadType")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "uploadType", valid_589036
  var valid_589037 = query.getOrDefault("key")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "key", valid_589037
  var valid_589038 = query.getOrDefault("$.xgafv")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("1"))
  if valid_589038 != nil:
    section.add "$.xgafv", valid_589038
  var valid_589039 = query.getOrDefault("pageSize")
  valid_589039 = validateParameter(valid_589039, JInt, required = false, default = nil)
  if valid_589039 != nil:
    section.add "pageSize", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589041: Call_CloudprivatecatalogProjectsVersionsSearch_589023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_589041.validator(path, query, header, formData, body)
  let scheme = call_589041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589041.url(scheme.get, call_589041.host, call_589041.base,
                         call_589041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589041, url, valid)

proc call*(call_589042: Call_CloudprivatecatalogProjectsVersionsSearch_589023;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudprivatecatalogProjectsVersionsSearch
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A pagination token returned from a previous call to SearchVersions
  ## that indicates where this listing should continue from.
  ## This field is optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The query to filter the versions. Required.
  ## 
  ## The supported queries are:
  ## * List versions under a product:
  ## `parent=catalogs/{catalog_id}/products/{product_id}`
  ## * Get a version by name:
  ## `name=catalogs/{catalog_id}/products/{product_id}/versions/{version_id}`
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
  ##           : Required. The name of the resource context. See
  ## SearchCatalogsRequest.resource for details.
  ##   pageSize: int
  ##           : The maximum number of entries that are requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589043 = newJObject()
  var query_589044 = newJObject()
  add(query_589044, "upload_protocol", newJString(uploadProtocol))
  add(query_589044, "fields", newJString(fields))
  add(query_589044, "pageToken", newJString(pageToken))
  add(query_589044, "quotaUser", newJString(quotaUser))
  add(query_589044, "alt", newJString(alt))
  add(query_589044, "query", newJString(query))
  add(query_589044, "oauth_token", newJString(oauthToken))
  add(query_589044, "callback", newJString(callback))
  add(query_589044, "access_token", newJString(accessToken))
  add(query_589044, "uploadType", newJString(uploadType))
  add(query_589044, "key", newJString(key))
  add(query_589044, "$.xgafv", newJString(Xgafv))
  add(path_589043, "resource", newJString(resource))
  add(query_589044, "pageSize", newJInt(pageSize))
  add(query_589044, "prettyPrint", newJBool(prettyPrint))
  result = call_589042.call(path_589043, query_589044, nil, nil, nil)

var cloudprivatecatalogProjectsVersionsSearch* = Call_CloudprivatecatalogProjectsVersionsSearch_589023(
    name: "cloudprivatecatalogProjectsVersionsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/versions:search",
    validator: validate_CloudprivatecatalogProjectsVersionsSearch_589024,
    base: "/", url: url_CloudprivatecatalogProjectsVersionsSearch_589025,
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
