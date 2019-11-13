
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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
  gcpServiceName = "cloudprivatecatalog"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudprivatecatalogFoldersCatalogsSearch_579635 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogFoldersCatalogsSearch_579637(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogFoldersCatalogsSearch_579636(path: JsonNode;
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
  var valid_579763 = path.getOrDefault("resource")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "resource", valid_579763
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
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("pageSize")
  valid_579781 = validateParameter(valid_579781, JInt, required = false, default = nil)
  if valid_579781 != nil:
    section.add "pageSize", valid_579781
  var valid_579782 = query.getOrDefault("alt")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = newJString("json"))
  if valid_579782 != nil:
    section.add "alt", valid_579782
  var valid_579783 = query.getOrDefault("uploadType")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "uploadType", valid_579783
  var valid_579784 = query.getOrDefault("quotaUser")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "quotaUser", valid_579784
  var valid_579785 = query.getOrDefault("pageToken")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "pageToken", valid_579785
  var valid_579786 = query.getOrDefault("query")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "query", valid_579786
  var valid_579787 = query.getOrDefault("callback")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "callback", valid_579787
  var valid_579788 = query.getOrDefault("fields")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "fields", valid_579788
  var valid_579789 = query.getOrDefault("access_token")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "access_token", valid_579789
  var valid_579790 = query.getOrDefault("upload_protocol")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "upload_protocol", valid_579790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579813: Call_CloudprivatecatalogFoldersCatalogsSearch_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Catalog resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_579813.validator(path, query, header, formData, body)
  let scheme = call_579813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579813.url(scheme.get, call_579813.host, call_579813.base,
                         call_579813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579813, url, valid)

proc call*(call_579884: Call_CloudprivatecatalogFoldersCatalogsSearch_579635;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogFoldersCatalogsSearch
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
  var path_579885 = newJObject()
  var query_579887 = newJObject()
  add(query_579887, "key", newJString(key))
  add(query_579887, "prettyPrint", newJBool(prettyPrint))
  add(query_579887, "oauth_token", newJString(oauthToken))
  add(query_579887, "$.xgafv", newJString(Xgafv))
  add(query_579887, "pageSize", newJInt(pageSize))
  add(query_579887, "alt", newJString(alt))
  add(query_579887, "uploadType", newJString(uploadType))
  add(query_579887, "quotaUser", newJString(quotaUser))
  add(path_579885, "resource", newJString(resource))
  add(query_579887, "pageToken", newJString(pageToken))
  add(query_579887, "query", newJString(query))
  add(query_579887, "callback", newJString(callback))
  add(query_579887, "fields", newJString(fields))
  add(query_579887, "access_token", newJString(accessToken))
  add(query_579887, "upload_protocol", newJString(uploadProtocol))
  result = call_579884.call(path_579885, query_579887, nil, nil, nil)

var cloudprivatecatalogFoldersCatalogsSearch* = Call_CloudprivatecatalogFoldersCatalogsSearch_579635(
    name: "cloudprivatecatalogFoldersCatalogsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/catalogs:search",
    validator: validate_CloudprivatecatalogFoldersCatalogsSearch_579636,
    base: "/", url: url_CloudprivatecatalogFoldersCatalogsSearch_579637,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogFoldersProductsSearch_579926 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogFoldersProductsSearch_579928(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogFoldersProductsSearch_579927(path: JsonNode;
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
  var valid_579929 = path.getOrDefault("resource")
  valid_579929 = validateParameter(valid_579929, JString, required = true,
                                 default = nil)
  if valid_579929 != nil:
    section.add "resource", valid_579929
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
  var valid_579930 = query.getOrDefault("key")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "key", valid_579930
  var valid_579931 = query.getOrDefault("prettyPrint")
  valid_579931 = validateParameter(valid_579931, JBool, required = false,
                                 default = newJBool(true))
  if valid_579931 != nil:
    section.add "prettyPrint", valid_579931
  var valid_579932 = query.getOrDefault("oauth_token")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "oauth_token", valid_579932
  var valid_579933 = query.getOrDefault("$.xgafv")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = newJString("1"))
  if valid_579933 != nil:
    section.add "$.xgafv", valid_579933
  var valid_579934 = query.getOrDefault("pageSize")
  valid_579934 = validateParameter(valid_579934, JInt, required = false, default = nil)
  if valid_579934 != nil:
    section.add "pageSize", valid_579934
  var valid_579935 = query.getOrDefault("alt")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = newJString("json"))
  if valid_579935 != nil:
    section.add "alt", valid_579935
  var valid_579936 = query.getOrDefault("uploadType")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "uploadType", valid_579936
  var valid_579937 = query.getOrDefault("quotaUser")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "quotaUser", valid_579937
  var valid_579938 = query.getOrDefault("pageToken")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "pageToken", valid_579938
  var valid_579939 = query.getOrDefault("query")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "query", valid_579939
  var valid_579940 = query.getOrDefault("callback")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "callback", valid_579940
  var valid_579941 = query.getOrDefault("fields")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "fields", valid_579941
  var valid_579942 = query.getOrDefault("access_token")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "access_token", valid_579942
  var valid_579943 = query.getOrDefault("upload_protocol")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "upload_protocol", valid_579943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579944: Call_CloudprivatecatalogFoldersProductsSearch_579926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Product resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_579944.validator(path, query, header, formData, body)
  let scheme = call_579944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579944.url(scheme.get, call_579944.host, call_579944.base,
                         call_579944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579944, url, valid)

proc call*(call_579945: Call_CloudprivatecatalogFoldersProductsSearch_579926;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogFoldersProductsSearch
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
  var path_579946 = newJObject()
  var query_579947 = newJObject()
  add(query_579947, "key", newJString(key))
  add(query_579947, "prettyPrint", newJBool(prettyPrint))
  add(query_579947, "oauth_token", newJString(oauthToken))
  add(query_579947, "$.xgafv", newJString(Xgafv))
  add(query_579947, "pageSize", newJInt(pageSize))
  add(query_579947, "alt", newJString(alt))
  add(query_579947, "uploadType", newJString(uploadType))
  add(query_579947, "quotaUser", newJString(quotaUser))
  add(path_579946, "resource", newJString(resource))
  add(query_579947, "pageToken", newJString(pageToken))
  add(query_579947, "query", newJString(query))
  add(query_579947, "callback", newJString(callback))
  add(query_579947, "fields", newJString(fields))
  add(query_579947, "access_token", newJString(accessToken))
  add(query_579947, "upload_protocol", newJString(uploadProtocol))
  result = call_579945.call(path_579946, query_579947, nil, nil, nil)

var cloudprivatecatalogFoldersProductsSearch* = Call_CloudprivatecatalogFoldersProductsSearch_579926(
    name: "cloudprivatecatalogFoldersProductsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/products:search",
    validator: validate_CloudprivatecatalogFoldersProductsSearch_579927,
    base: "/", url: url_CloudprivatecatalogFoldersProductsSearch_579928,
    schemes: {Scheme.Https})
type
  Call_CloudprivatecatalogFoldersVersionsSearch_579948 = ref object of OpenApiRestCall_579364
proc url_CloudprivatecatalogFoldersVersionsSearch_579950(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudprivatecatalogFoldersVersionsSearch_579949(path: JsonNode;
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
  var valid_579951 = path.getOrDefault("resource")
  valid_579951 = validateParameter(valid_579951, JString, required = true,
                                 default = nil)
  if valid_579951 != nil:
    section.add "resource", valid_579951
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
  var valid_579952 = query.getOrDefault("key")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "key", valid_579952
  var valid_579953 = query.getOrDefault("prettyPrint")
  valid_579953 = validateParameter(valid_579953, JBool, required = false,
                                 default = newJBool(true))
  if valid_579953 != nil:
    section.add "prettyPrint", valid_579953
  var valid_579954 = query.getOrDefault("oauth_token")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "oauth_token", valid_579954
  var valid_579955 = query.getOrDefault("$.xgafv")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = newJString("1"))
  if valid_579955 != nil:
    section.add "$.xgafv", valid_579955
  var valid_579956 = query.getOrDefault("pageSize")
  valid_579956 = validateParameter(valid_579956, JInt, required = false, default = nil)
  if valid_579956 != nil:
    section.add "pageSize", valid_579956
  var valid_579957 = query.getOrDefault("alt")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = newJString("json"))
  if valid_579957 != nil:
    section.add "alt", valid_579957
  var valid_579958 = query.getOrDefault("uploadType")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "uploadType", valid_579958
  var valid_579959 = query.getOrDefault("quotaUser")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "quotaUser", valid_579959
  var valid_579960 = query.getOrDefault("pageToken")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "pageToken", valid_579960
  var valid_579961 = query.getOrDefault("query")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "query", valid_579961
  var valid_579962 = query.getOrDefault("callback")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "callback", valid_579962
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("access_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "access_token", valid_579964
  var valid_579965 = query.getOrDefault("upload_protocol")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "upload_protocol", valid_579965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579966: Call_CloudprivatecatalogFoldersVersionsSearch_579948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search Version resources that consumers have access to, within the
  ## scope of the consumer cloud resource hierarchy context.
  ## 
  let valid = call_579966.validator(path, query, header, formData, body)
  let scheme = call_579966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579966.url(scheme.get, call_579966.host, call_579966.base,
                         call_579966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579966, url, valid)

proc call*(call_579967: Call_CloudprivatecatalogFoldersVersionsSearch_579948;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudprivatecatalogFoldersVersionsSearch
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
  var path_579968 = newJObject()
  var query_579969 = newJObject()
  add(query_579969, "key", newJString(key))
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  add(query_579969, "pageSize", newJInt(pageSize))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(path_579968, "resource", newJString(resource))
  add(query_579969, "pageToken", newJString(pageToken))
  add(query_579969, "query", newJString(query))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  result = call_579967.call(path_579968, query_579969, nil, nil, nil)

var cloudprivatecatalogFoldersVersionsSearch* = Call_CloudprivatecatalogFoldersVersionsSearch_579948(
    name: "cloudprivatecatalogFoldersVersionsSearch", meth: HttpMethod.HttpGet,
    host: "cloudprivatecatalog.googleapis.com",
    route: "/v1beta1/{resource}/versions:search",
    validator: validate_CloudprivatecatalogFoldersVersionsSearch_579949,
    base: "/", url: url_CloudprivatecatalogFoldersVersionsSearch_579950,
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
